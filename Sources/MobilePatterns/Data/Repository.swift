/// Where ``Repository`` reads a value from: the *strategy* for one call.
public enum CachePolicy: Sendable, Equatable {
    /// Return a fresh cached value; fetch only when there is none or it expired.
    case cacheFirst
    /// Fetch; when the fetch fails, fall back to a cached value, even an expired one.
    case networkFirst
    /// Always fetch and store the result, for pull to refresh.
    case reloadIgnoringCache
    /// Never fetch; throw ``RepositoryError/notCached`` when there is no fresh value.
    case cacheOnly
}

/// Why ``Repository`` returned no value.
public enum RepositoryError: Error, Equatable, Sendable {
    /// ``CachePolicy/cacheOnly`` found no fresh value.
    case notCached
}

/// One place that owns a kind of data, its fetch and its in-memory cache: the *repository*
/// pattern.
///
/// Screens ask the repository for a value and a ``CachePolicy`` instead of calling the network
/// themselves. Concurrent requests for the same key share one fetch, and a fetch runs to its end
/// even when the caller that started it is cancelled, so the others still get its value. The
/// cache holds at most `capacity` entries and drops the least recently used one beyond that
/// (finding it scans the entries, which suits the hundreds of entries a screen cache holds);
/// entries older than `timeToLive` count as expired.
///
/// ```swift
/// let articles = Repository<Int, Article>(capacity: 200, timeToLive: .seconds(300)) { id in
///     try await api.article(id: id)
/// }
/// let cached = try await articles.value(for: 42)                                // cache first
/// let fresh = try await articles.value(for: 42, policy: .reloadIgnoringCache)   // refresh
///
/// for try await article in articles.updates(for: 42) { show(article) }          // cached, then fresh
/// ```
public actor Repository<Key: Hashable & Sendable, Value: Sendable> {
    private struct Entry {
        var value: Value
        var storedAt: ContinuousClock.Instant
        var lastUsed: UInt64
    }

    /// Most entries kept in memory.
    public nonisolated let capacity: Int
    /// Age after which an entry counts as expired, or `nil` for entries that never expire.
    public nonisolated let timeToLive: Duration?

    private let fetch: @Sendable (Key) async throws -> Value
    private let now: @Sendable () -> ContinuousClock.Instant
    private struct Flight {
        let task: Task<Value, any Error>
        /// Set when the key was stored, invalidated or cleared while the fetch ran.
        var isOutdated = false
    }

    private var entries: [Key: Entry] = [:]
    private var useCounter: UInt64 = 0
    private var inFlight: [Key: Flight] = [:]

    /// Number of calls that joined a running fetch instead of starting one, for tests.
    private(set) var joinedCount = 0

    /// Creates a repository.
    ///
    /// - Parameters:
    ///   - capacity: Most entries kept. Values below 1 are treated as 1.
    ///   - timeToLive: Age after which an entry is expired. `nil`, zero or a negative value means
    ///     entries never expire.
    ///   - now: The current time; inject a fixed clock in tests.
    ///   - fetch: Loads the value for a key from its source of truth.
    public init(
        capacity: Int = 100,
        timeToLive: Duration? = nil,
        now: @escaping @Sendable () -> ContinuousClock.Instant = { .now },
        fetch: @escaping @Sendable (Key) async throws -> Value
    ) {
        self.capacity = max(1, capacity)
        self.timeToLive = timeToLive.flatMap { $0 > .zero ? $0 : nil }
        self.now = now
        self.fetch = fetch
    }

    /// Number of cached entries, expired ones included.
    public var count: Int { entries.count }

    /// Returns the value for `key` following `policy`.
    public func value(for key: Key, policy: CachePolicy = .cacheFirst) async throws -> Value {
        switch policy {
        case .cacheFirst:
            if let fresh = cached(key, allowExpired: false) { return fresh }
            return try await load(key)
        case .cacheOnly:
            guard let fresh = cached(key, allowExpired: false) else { throw RepositoryError.notCached }
            return fresh
        case .reloadIgnoringCache:
            return try await load(key)
        case .networkFirst:
            do {
                return try await load(key)
            } catch {
                if error is CancellationError { throw error }
                guard let fallback = cached(key, allowExpired: true) else { throw error }
                return fallback
            }
        }
    }

    /// Yields the cached value for `key` at once when there is one (expired or not), then the
    /// fetched value: *stale while revalidate*.
    ///
    /// When the fetch fails after a cached value was yielded, the stream finishes with the
    /// error, so the screen can keep the old value and show a banner.
    public nonisolated func updates(for key: Key) -> AsyncThrowingStream<Value, any Error> {
        AsyncThrowingStream { continuation in
            let task = Task {
                if let cached = await self.cached(key, allowExpired: true) {
                    continuation.yield(cached)
                }
                do {
                    continuation.yield(try await self.load(key))
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
            continuation.onTermination = { _ in task.cancel() }
        }
    }

    /// Stores `value` for `key`, for example after the app changed it locally.
    public func store(_ value: Value, for key: Key) {
        inFlight[key]?.isOutdated = true
        insert(value, for: key)
    }

    /// Removes the entry for `key`. A fetch that is running for it is not stored when it ends.
    public func invalidate(_ key: Key) {
        inFlight[key]?.isOutdated = true
        entries[key] = nil
    }

    /// Removes every entry. Fetches that are running are not stored when they end.
    public func removeAll() {
        for key in inFlight.keys { inFlight[key]?.isOutdated = true }
        entries.removeAll()
    }

    private func cached(_ key: Key, allowExpired: Bool) -> Value? {
        guard var entry = entries[key] else { return nil }
        if !allowExpired, let timeToLive, now() - entry.storedAt >= timeToLive { return nil }
        useCounter &+= 1
        entry.lastUsed = useCounter
        entries[key] = entry
        return entry.value
    }

    private func load(_ key: Key) async throws -> Value {
        if let running = inFlight[key] {
            joinedCount += 1
            return try await running.task.value
        }
        let fetch = self.fetch
        let flight = Flight(task: Task { try await fetch(key) })
        inFlight[key] = flight
        let result = await flight.task.result
        let isOutdated = inFlight[key]?.isOutdated ?? true
        inFlight[key] = nil
        let value = try result.get()
        if !isOutdated { insert(value, for: key) }
        return value
    }

    private func insert(_ value: Value, for key: Key) {
        useCounter &+= 1
        entries[key] = Entry(value: value, storedAt: now(), lastUsed: useCounter)
        if entries.count > capacity, let oldest = entries.min(by: { $0.value.lastUsed < $1.value.lastUsed })?.key {
            entries[oldest] = nil
        }
    }
}
