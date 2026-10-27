import Foundation
import Testing
@testable import MobilePatterns

@Suite("withCompletion")
struct CompletionBridgeTests {
    @Test func returnsTheSuccessValue() async throws {
        let value = try await withCompletion { completion in
            DispatchQueue.global().async { completion(.success(42)) }
        }
        #expect(value == 42)
    }

    @Test func throwsTheFailure() async {
        await #expect(throws: TestError(code: 3)) {
            let _: Int = try await withCompletion { completion in completion(.failure(TestError(code: 3))) }
        }
    }

    @Test func secondCallbackIsIgnoredInsteadOfCrashing() async throws {
        let saved = SavedCompletion<String>()
        let value = try await withCompletion { completion in
            saved.store(completion)
            completion(.success("first"))
            completion(.success("second"))
            completion(.failure(TestError(code: 1)))
        }
        #expect(value == "first")
        saved.call(.success("after return"))
    }

    @Test func cancellationWhileWaitingReturnsAtOnce() async {
        let saved = SavedCompletion<Int>()
        let cancels = CallCounter()
        let task = Task {
            try await withCompletion(onCancel: { cancels.increment() }) { completion in
                saved.store(completion)
            }
        }
        #expect(await waitUntil { saved.isStored })
        task.cancel()
        await #expect(throws: CancellationError.self) { try await task.value }
        #expect(cancels.count == 1)
        saved.call(.success(1))
        #expect(cancels.count == 1)
    }

    @Test func alreadyCancelledTaskNeverStartsTheWork() async {
        let starts = CallCounter()
        let cancels = CallCounter()
        let task = Task {
            while !Task.isCancelled { await Task.yield() }
            let _: Int = try await withCompletion(onCancel: { cancels.increment() }) { _ in starts.increment() }
        }
        task.cancel()
        await #expect(throws: CancellationError.self) { try await task.value }
        #expect(starts.count == 0)
        #expect(cancels.count == 0)
    }
}

/// Keeps a completion handler so a test can call it later.
final class SavedCompletion<Value: Sendable>: Sendable {
    private let handler = OSAllocatedUnfairLock<(@Sendable (Result<Value, any Error>) -> Void)?>(initialState: nil)

    var isStored: Bool { handler.withLock { $0 != nil } }

    func store(_ completion: @escaping @Sendable (Result<Value, any Error>) -> Void) {
        handler.withLock { $0 = completion }
    }

    func call(_ result: Result<Value, any Error>) {
        handler.withLock { $0 }?(result)
    }
}

import os

@Suite("Broadcaster")
struct BroadcasterTests {
    @Test func everySubscriberGetsEveryEvent() async {
        let broadcaster = Broadcaster<Int>()
        let first = broadcaster.events()
        let second = broadcaster.events()
        #expect(broadcaster.subscriberCount == 2)
        for event in 1...3 { broadcaster.send(event) }
        broadcaster.finish()
        #expect(await Array(first) == [1, 2, 3])
        #expect(await Array(second) == [1, 2, 3])
    }

    @Test func lateSubscriberMissesEarlierEvents() async {
        let broadcaster = Broadcaster<Int>()
        broadcaster.send(1)
        let late = broadcaster.events()
        broadcaster.send(2)
        broadcaster.finish()
        #expect(await Array(late) == [2])
    }

    @Test func slowSubscriberKeepsOnlyTheNewestEvents() async {
        let broadcaster = Broadcaster<Int>(bufferSize: 2)
        let stream = broadcaster.events()
        for event in 1...100 { broadcaster.send(event) }
        broadcaster.finish()
        #expect(await Array(stream) == [99, 100])
    }

    @Test func bufferSizeBelowOneBecomesOne() async {
        let broadcaster = Broadcaster<Int>(bufferSize: 0)
        #expect(broadcaster.bufferSize == 1)
        let stream = broadcaster.events()
        broadcaster.send(1)
        broadcaster.send(2)
        broadcaster.finish()
        #expect(await Array(stream) == [2])
    }

    @Test func cancelledSubscriberIsRemoved() async {
        let broadcaster = Broadcaster<Int>()
        let stream = broadcaster.events()
        let task = Task { for await _ in stream {} }
        #expect(broadcaster.subscriberCount == 1)
        task.cancel()
        await task.value
        #expect(await waitUntil { broadcaster.subscriberCount == 0 })
    }

    @Test func finishEndsCurrentAndFutureStreams() async {
        let broadcaster = Broadcaster<Int>()
        let current = broadcaster.events()
        broadcaster.finish()
        broadcaster.send(1)
        #expect(broadcaster.subscriberCount == 0)
        #expect(await Array(current).isEmpty)
        #expect(await Array(broadcaster.events()).isEmpty)
        #expect(broadcaster.subscriberCount == 0)
    }
}

extension Array {
    init(_ sequence: AsyncStream<Element>) async {
        var elements: [Element] = []
        for await element in sequence { elements.append(element) }
        self = elements
    }
}
