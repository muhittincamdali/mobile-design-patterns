import os

/// Sends each event to every current subscriber as an `AsyncStream`: the *observer* pattern with
/// Swift concurrency.
///
/// Unlike a single `AsyncStream`, which hands each element to only one consumer, every stream
/// from ``events()`` gets every event sent after it was created. A subscriber leaves when its
/// loop ends or its task is cancelled. Each subscriber has its own buffer of at most
/// `bufferSize` events; a subscriber that falls behind loses the oldest ones instead of letting
/// memory grow.
///
/// ```swift
/// let cartChanges = Broadcaster<CartEvent>()
///
/// // Badge on the tab bar
/// Task { for await event in cartChanges.events() { badge.apply(event) } }
/// // Analytics
/// Task { for await event in cartChanges.events() { tracker.record(event) } }
///
/// cartChanges.send(.added(itemID: 7))
/// ```
public final class Broadcaster<Event: Sendable>: Sendable {
    private struct State {
        var subscribers: [UInt64: AsyncStream<Event>.Continuation] = [:]
        var nextID: UInt64 = 0
        var isFinished = false
    }

    /// Most events buffered per subscriber.
    public let bufferSize: Int

    private let state = OSAllocatedUnfairLock(initialState: State())

    /// Creates a broadcaster.
    ///
    /// - Parameter bufferSize: Most events kept for a subscriber that has not read them yet.
    ///   Values below 1 are treated as 1.
    public init(bufferSize: Int = 64) {
        self.bufferSize = max(1, bufferSize)
    }

    /// Number of streams currently subscribed.
    public var subscriberCount: Int {
        state.withLock { $0.subscribers.count }
    }

    /// Returns a new stream that receives every event sent from now on. After ``finish()`` it
    /// returns a stream that is already finished.
    public func events() -> AsyncStream<Event> {
        let (stream, continuation) = AsyncStream.makeStream(of: Event.self, bufferingPolicy: .bufferingNewest(bufferSize))
        let id: UInt64? = state.withLock { state in
            guard !state.isFinished else { return nil }
            let id = state.nextID
            state.nextID &+= 1
            state.subscribers[id] = continuation
            return id
        }
        guard let id else {
            continuation.finish()
            return stream
        }
        continuation.onTermination = { [weak self] _ in
            self?.state.withLock { _ = $0.subscribers.removeValue(forKey: id) }
        }
        return stream
    }

    /// Sends `event` to every subscriber. Does nothing after ``finish()``.
    public func send(_ event: Event) {
        let subscribers = state.withLock { Array($0.subscribers.values) }
        for subscriber in subscribers {
            subscriber.yield(event)
        }
    }

    /// Ends every stream; their loops finish after the buffered events. Later calls to
    /// ``events()`` return finished streams.
    public func finish() {
        let subscribers: [AsyncStream<Event>.Continuation] = state.withLock { state in
            state.isFinished = true
            defer { state.subscribers.removeAll() }
            return Array(state.subscribers.values)
        }
        for subscriber in subscribers {
            subscriber.finish()
        }
    }
}
