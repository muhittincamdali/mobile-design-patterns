import Foundation
import os

/// Counts calls from any task.
final class CallCounter: Sendable {
    private let value = OSAllocatedUnfairLock(initialState: 0)

    var count: Int { value.withLock { $0 } }

    @discardableResult
    func increment() -> Int {
        value.withLock { count in
            count += 1
            return count
        }
    }
}

/// Suspends callers of `wait()` until `open()` is called.
actor Gate {
    private var isOpen = false
    private var waiters: [CheckedContinuation<Void, Never>] = []

    func wait() async {
        if isOpen { return }
        await withCheckedContinuation { waiters.append($0) }
    }

    func open() {
        isOpen = true
        for waiter in waiters { waiter.resume() }
        waiters.removeAll()
    }
}

/// A clock the test moves by hand.
final class ManualTime: Sendable {
    private let offset = OSAllocatedUnfairLock(initialState: Duration.zero)
    private let start = ContinuousClock.now

    var now: ContinuousClock.Instant { start + offset.withLock { $0 } }

    func advance(by duration: Duration) {
        offset.withLock { $0 += duration }
    }
}

/// Yields until `condition` holds; gives up after `attempts` yields so a broken test fails
/// instead of hanging.
func waitUntil(
    attempts: Int = 100_000,
    isolation: isolated (any Actor)? = #isolation,
    _ condition: () async -> Bool
) async -> Bool {
    for _ in 0..<attempts {
        if await condition() { return true }
        await Task.yield()
    }
    return await condition()
}

struct TestError: Error, Equatable {
    let code: Int
}
