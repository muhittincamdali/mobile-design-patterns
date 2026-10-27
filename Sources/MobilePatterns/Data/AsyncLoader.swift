/// An asynchronous function from an input to an output that can be wrapped in more behaviour:
/// the *decorator* pattern for `async` code.
///
/// Each decorator returns a new loader that calls the one it wraps, so behaviour is added in
/// layers without touching the networking code:
///
/// ```swift
/// let loadArticle = AsyncLoader<Int, Article> { id in try await api.article(id: id) }
///     .timeout(.seconds(10))
///     .retrying(maxAttempts: 3, delay: .milliseconds(300))
///     .coalescing()
///
/// let article = try await loadArticle(42)
/// ```
///
/// The order matters: decorators run from the outside in. Above, two screens that ask for the
/// same article at once share one retried request, and each attempt has its own time limit.
public struct AsyncLoader<Input: Sendable, Output: Sendable>: Sendable {
    private let body: @Sendable (Input) async throws -> Output

    /// Wraps `body`.
    public init(_ body: @escaping @Sendable (Input) async throws -> Output) {
        self.body = body
    }

    /// The most calls ``retrying(maxAttempts:delay:when:)`` makes, whatever count it is given.
    public static var maxRetryAttempts: Int { 100 }

    /// Runs the loader.
    public func callAsFunction(_ input: Input) async throws -> Output {
        try await body(input)
    }

    /// Retries failed calls.
    ///
    /// Cancellation is never retried, and neither is an error for which `shouldRetry` returns
    /// `false`. The delay between attempts is cancellable.
    ///
    /// - Parameters:
    ///   - maxAttempts: Total number of calls, the first one included. Values below 1 are treated
    ///     as 1 and values above ``maxRetryAttempts`` as that limit, so a misconfigured count
    ///     cannot keep a failing call looping.
    ///   - delay: Wait between two attempts. Negative values are treated as zero.
    ///   - shouldRetry: Decides whether an error is worth another attempt.
    public func retrying(
        maxAttempts: Int,
        delay: Duration = .zero,
        when shouldRetry: @escaping @Sendable (any Error) -> Bool = { _ in true }
    ) -> AsyncLoader {
        let attempts = min(max(1, maxAttempts), Self.maxRetryAttempts)
        let pause = max(.zero, delay)
        return AsyncLoader { input in
            var attempt = 1
            while true {
                do {
                    return try await self(input)
                } catch {
                    if error is CancellationError || Task.isCancelled { throw error }
                    guard attempt < attempts, shouldRetry(error) else { throw error }
                }
                attempt += 1
                if pause > .zero { try await Task.sleep(for: pause) }
            }
        }
    }

    /// Fails with ``AsyncLoaderTimeoutError`` when a call takes longer than `limit`, and cancels
    /// the call.
    ///
    /// The wrapped loader must react to cancellation (as `URLSession` and `Task.sleep` do):
    /// the decorator waits for the cancelled call to return before it throws.
    ///
    /// - Parameter limit: The time allowed. Zero or a negative value fails every call at once.
    public func timeout(_ limit: Duration) -> AsyncLoader {
        AsyncLoader { input in
            guard limit > .zero else { throw AsyncLoaderTimeoutError(limit: limit) }
            return try await withThrowingTaskGroup(of: Output?.self) { group in
                group.addTask { try await self(input) }
                group.addTask {
                    try await Task.sleep(for: limit)
                    return nil
                }
                defer { group.cancelAll() }
                guard let first = try await group.next(), let output = first else {
                    throw AsyncLoaderTimeoutError(limit: limit)
                }
                return output
            }
        }
    }

    /// Shares one call among concurrent callers that ask for the same input: the *proxy*
    /// pattern.
    ///
    /// While a call for an input is running, more calls with an equal input wait for it instead
    /// of starting their own; they all get the same output or error. Once it finishes, the next
    /// call starts a new one, so nothing is cached and memory only holds the calls in flight.
    ///
    /// Cancelling one waiting caller does not cancel the shared call for the others.
    public func coalescing() -> AsyncLoader where Input: Hashable {
        coalescing(using: InFlightCalls())
    }

    func coalescing(using inFlight: InFlightCalls<Input, Output>) -> AsyncLoader where Input: Hashable {
        AsyncLoader { input in
            try await inFlight.run(for: input) { try await self(input) }
        }
    }
}

/// The error of ``AsyncLoader/timeout(_:)``.
public struct AsyncLoaderTimeoutError: Error, Equatable, Sendable {
    /// The time that was allowed.
    public let limit: Duration
}

/// The calls ``AsyncLoader/coalescing()`` is waiting for, one per input.
actor InFlightCalls<Key: Hashable & Sendable, Value: Sendable> {
    private var tasks: [Key: Task<Value, any Error>] = [:]

    /// Number of calls that joined a running call instead of starting one, for tests.
    private(set) var joinedCount = 0

    func run(for key: Key, _ operation: @escaping @Sendable () async throws -> Value) async throws -> Value {
        if let running = tasks[key] {
            joinedCount += 1
            return try await running.value
        }
        let task = Task { try await operation() }
        tasks[key] = task
        defer { tasks[key] = nil }
        return try await task.value
    }
}
