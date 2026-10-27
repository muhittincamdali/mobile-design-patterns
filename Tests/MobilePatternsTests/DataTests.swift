import Foundation
import Testing
@testable import MobilePatterns

@Suite("AsyncLoader")
struct AsyncLoaderTests {
    @Test func retryingSucceedsOnALaterAttempt() async throws {
        let calls = CallCounter()
        let loader = AsyncLoader<Int, Int> { input in
            if calls.increment() < 3 { throw TestError(code: 1) }
            return input * 2
        }.retrying(maxAttempts: 3)
        #expect(try await loader(21) == 42)
        #expect(calls.count == 3)
    }

    @Test func retryingGivesUpAfterMaxAttempts() async {
        let calls = CallCounter()
        let loader = AsyncLoader<Int, Int> { _ in
            calls.increment()
            throw TestError(code: calls.count)
        }.retrying(maxAttempts: 4)
        await #expect(throws: TestError(code: 4)) { try await loader(0) }
        #expect(calls.count == 4)
    }

    @Test func retryingWithNonPositiveAttemptsCallsOnce() async {
        for attempts in [0, -10, Int.min] {
            let calls = CallCounter()
            let loader = AsyncLoader<Int, Int> { _ in
                calls.increment()
                throw TestError(code: 0)
            }.retrying(maxAttempts: attempts, delay: .seconds(-5))
            await #expect(throws: TestError.self) { try await loader(0) }
            #expect(calls.count == 1)
        }
    }

    @Test func retryingNeverExceedsTheAttemptCap() async {
        let calls = CallCounter()
        let loader = AsyncLoader<Int, Int> { _ in
            calls.increment()
            throw TestError(code: 0)
        }.retrying(maxAttempts: Int.max)
        await #expect(throws: TestError.self) { try await loader(0) }
        #expect(calls.count == AsyncLoader<Int, Int>.maxRetryAttempts)
    }

    @Test func retryingRespectsThePredicate() async {
        let calls = CallCounter()
        let loader = AsyncLoader<Int, Int> { _ in
            calls.increment()
            throw TestError(code: 404)
        }.retrying(maxAttempts: 5) { ($0 as? TestError)?.code != 404 }
        await #expect(throws: TestError(code: 404)) { try await loader(0) }
        #expect(calls.count == 1)
    }

    @Test func retryingNeverRetriesCancellation() async {
        let calls = CallCounter()
        let loader = AsyncLoader<Int, Int> { _ in
            calls.increment()
            throw CancellationError()
        }.retrying(maxAttempts: 5)
        await #expect(throws: CancellationError.self) { try await loader(0) }
        #expect(calls.count == 1)
    }

    @Test func timeoutFailsASlowCallAndCancelsIt() async {
        let loader = AsyncLoader<Int, Int> { input in
            try await Task.sleep(for: .seconds(30))
            return input
        }.timeout(.milliseconds(20))
        let started = ContinuousClock.now
        await #expect(throws: AsyncLoaderTimeoutError(limit: .milliseconds(20))) { try await loader(1) }
        #expect(ContinuousClock.now - started < .seconds(10))
    }

    @Test func timeoutPassesFastResultsAndErrorsThrough() async throws {
        let fast = AsyncLoader<Int, Int> { $0 + 1 }.timeout(.seconds(30))
        #expect(try await fast(1) == 2)
        let failing = AsyncLoader<Int, Int> { _ in throw TestError(code: 7) }.timeout(.seconds(30))
        await #expect(throws: TestError(code: 7)) { try await failing(1) }
    }

    @Test func zeroTimeoutFailsWithoutCalling() async {
        let calls = CallCounter()
        let loader = AsyncLoader<Int, Int> { input in
            calls.increment()
            return input
        }
        for limit in [Duration.zero, .seconds(-1)] {
            await #expect(throws: AsyncLoaderTimeoutError.self) { try await loader.timeout(limit)(1) }
        }
        #expect(calls.count == 0)
    }

    @Test func coalescingSharesOneCallPerInput() async throws {
        let calls = CallCounter()
        let gate = Gate()
        let inFlight = InFlightCalls<Int, String>()
        let loader = AsyncLoader<Int, String> { input in
            calls.increment()
            await gate.wait()
            return "value \(input)"
        }.coalescing(using: inFlight)

        let results = try await withThrowingTaskGroup(of: String.self) { group in
            for _ in 0..<5 { group.addTask { try await loader(1) } }
            #expect(await waitUntil { await inFlight.joinedCount == 4 })
            await gate.open()
            return try await group.reduce(into: []) { $0.append($1) }
        }
        #expect(results == Array(repeating: "value 1", count: 5))
        #expect(calls.count == 1)

        #expect(try await loader(1) == "value 1")
        #expect(try await loader(2) == "value 2")
        #expect(calls.count == 3)
    }

    @Test func coalescingSharesErrorsToo() async {
        let gate = Gate()
        let inFlight = InFlightCalls<Int, Int>()
        let loader = AsyncLoader<Int, Int> { _ in
            await gate.wait()
            throw TestError(code: 9)
        }.coalescing(using: inFlight)
        async let first = Result { try await loader(1) }
        async let second = Result { try await loader(1) }
        #expect(await waitUntil { await inFlight.joinedCount == 1 })
        await gate.open()
        for result in await [first, second] {
            #expect(throws: TestError(code: 9)) { try result.get() }
        }
    }
}

extension Result where Failure == any Error {
    init(catching body: () async throws -> Success) async {
        do { self = .success(try await body()) } catch { self = .failure(error) }
    }
}

@Suite("Repository")
struct RepositoryTests {
    final class Source: Sendable {
        let calls = CallCounter()
        let failing = CallCounter()

        func fetch(_ key: String) async throws -> String {
            let call = calls.increment()
            if failing.count > 0 { throw TestError(code: call) }
            return "\(key)#\(call)"
        }
    }

    @Test func cacheFirstFetchesOnce() async throws {
        let source = Source()
        let repository = Repository<String, String>(fetch: source.fetch)
        #expect(try await repository.value(for: "a") == "a#1")
        #expect(try await repository.value(for: "a") == "a#1")
        #expect(source.calls.count == 1)
    }

    @Test func expiredEntriesAreFetchedAgain() async throws {
        let source = Source()
        let time = ManualTime()
        let repository = Repository<String, String>(timeToLive: .seconds(60), now: { time.now }, fetch: source.fetch)
        _ = try await repository.value(for: "a")
        time.advance(by: .seconds(59))
        #expect(try await repository.value(for: "a") == "a#1")
        time.advance(by: .seconds(1))
        #expect(try await repository.value(for: "a") == "a#2")
    }

    @Test func nonPositiveTimeToLiveNeverExpires() async throws {
        for ttl in [Duration.zero, .seconds(-1)] {
            let source = Source()
            let time = ManualTime()
            let repository = Repository<String, String>(timeToLive: ttl, now: { time.now }, fetch: source.fetch)
            _ = try await repository.value(for: "a")
            time.advance(by: .seconds(86_400 * 365))
            #expect(try await repository.value(for: "a", policy: .cacheOnly) == "a#1")
            #expect(repository.timeToLive == nil)
        }
    }

    @Test func cacheOnlyNeverFetches() async throws {
        let source = Source()
        let repository = Repository<String, String>(fetch: source.fetch)
        await #expect(throws: RepositoryError.notCached) { try await repository.value(for: "a", policy: .cacheOnly) }
        #expect(source.calls.count == 0)
        await repository.store("local", for: "a")
        #expect(try await repository.value(for: "a", policy: .cacheOnly) == "local")
    }

    @Test func reloadIgnoresAFreshEntry() async throws {
        let source = Source()
        let repository = Repository<String, String>(fetch: source.fetch)
        _ = try await repository.value(for: "a")
        #expect(try await repository.value(for: "a", policy: .reloadIgnoringCache) == "a#2")
        #expect(try await repository.value(for: "a") == "a#2")
    }

    @Test func networkFirstFallsBackToAnExpiredEntry() async throws {
        let source = Source()
        let time = ManualTime()
        let repository = Repository<String, String>(timeToLive: .seconds(1), now: { time.now }, fetch: source.fetch)
        _ = try await repository.value(for: "a")
        time.advance(by: .seconds(10))
        source.failing.increment()
        #expect(try await repository.value(for: "a", policy: .networkFirst) == "a#1")
        await #expect(throws: TestError(code: 3)) { try await repository.value(for: "b", policy: .networkFirst) }
    }

    @Test func leastRecentlyUsedEntryIsDropped() async throws {
        let source = Source()
        let repository = Repository<String, String>(capacity: 2, fetch: source.fetch)
        _ = try await repository.value(for: "a")
        _ = try await repository.value(for: "b")
        _ = try await repository.value(for: "a")
        _ = try await repository.value(for: "c")
        #expect(await repository.count == 2)
        #expect(try await repository.value(for: "a", policy: .cacheOnly) == "a#1")
        await #expect(throws: RepositoryError.notCached) { try await repository.value(for: "b", policy: .cacheOnly) }
    }

    @Test func capacityBelowOneKeepsOneEntry() async throws {
        let repository = Repository<String, String>(capacity: 0, fetch: Source().fetch)
        #expect(repository.capacity == 1)
        _ = try await repository.value(for: "a")
        _ = try await repository.value(for: "b")
        #expect(await repository.count == 1)
    }

    @Test func concurrentRequestsShareOneFetch() async throws {
        let calls = CallCounter()
        let gate = Gate()
        let repository = Repository<Int, Int> { key in
            calls.increment()
            await gate.wait()
            return key * 10
        }
        let values = try await withThrowingTaskGroup(of: Int.self) { group in
            for _ in 0..<4 { group.addTask { try await repository.value(for: 1) } }
            #expect(await waitUntil { await repository.joinedCount == 3 })
            await gate.open()
            return try await group.reduce(into: []) { $0.append($1) }
        }
        #expect(values == [10, 10, 10, 10])
        #expect(calls.count == 1)
    }

    @Test func invalidatedFetchIsNotStored() async throws {
        let gate = Gate()
        let calls = CallCounter()
        let repository = Repository<Int, Int> { key in
            calls.increment()
            await gate.wait()
            return key
        }
        async let value = repository.value(for: 5)
        #expect(await waitUntil { calls.count == 1 })
        await repository.invalidate(5)
        await gate.open()
        #expect(try await value == 5)
        await #expect(throws: RepositoryError.notCached) { try await repository.value(for: 5, policy: .cacheOnly) }
    }

    @Test func storeDuringAFetchWins() async throws {
        let gate = Gate()
        let calls = CallCounter()
        let repository = Repository<Int, String> { _ in
            calls.increment()
            await gate.wait()
            return "server"
        }
        async let value = repository.value(for: 1)
        #expect(await waitUntil { calls.count == 1 })
        await repository.store("local edit", for: 1)
        await gate.open()
        #expect(try await value == "server")
        #expect(try await repository.value(for: 1, policy: .cacheOnly) == "local edit")
    }

    @Test func callsAfterInvalidateDoNotJoinTheOldFetch() async throws {
        let firstGate = Gate()
        let calls = CallCounter()
        let repository = Repository<Int, String> { _ in
            let call = calls.increment()
            if call == 1 { await firstGate.wait() }
            return "fetch \(call)"
        }
        async let old = repository.value(for: 1)
        #expect(await waitUntil { calls.count == 1 })
        await repository.invalidate(1)
        #expect(try await repository.value(for: 1) == "fetch 2")
        #expect(await repository.joinedCount == 0)
        await firstGate.open()
        #expect(try await old == "fetch 1")
        #expect(try await repository.value(for: 1, policy: .cacheOnly) == "fetch 2")
    }

    @Test func reloadAfterStoreDoesNotJoinTheOldFetch() async throws {
        let firstGate = Gate()
        let calls = CallCounter()
        let repository = Repository<Int, String> { _ in
            let call = calls.increment()
            if call == 1 { await firstGate.wait() }
            return "fetch \(call)"
        }
        async let old = repository.value(for: 1)
        #expect(await waitUntil { calls.count == 1 })
        await repository.store("local edit", for: 1)
        #expect(try await repository.value(for: 1, policy: .reloadIgnoringCache) == "fetch 2")
        await firstGate.open()
        #expect(try await old == "fetch 1")
        #expect(try await repository.value(for: 1, policy: .cacheOnly) == "fetch 2")
    }

    @Test func removeAllEmptiesTheCache() async throws {
        let source = Source()
        let repository = Repository<String, String>(fetch: source.fetch)
        _ = try await repository.value(for: "a")
        _ = try await repository.value(for: "b")
        await repository.removeAll()
        #expect(await repository.count == 0)
        #expect(try await repository.value(for: "a") == "a#3")
    }

    @Test func updatesYieldCachedThenFresh() async throws {
        let source = Source()
        let repository = Repository<String, String>(fetch: source.fetch)
        var seen: [String] = []
        for try await value in repository.updates(for: "a") { seen.append(value) }
        #expect(seen == ["a#1"])
        seen = []
        for try await value in repository.updates(for: "a") { seen.append(value) }
        #expect(seen == ["a#1", "a#2"])
    }

    @Test func updatesFinishWithTheErrorAfterTheCachedValue() async throws {
        let source = Source()
        let repository = Repository<String, String>(fetch: source.fetch)
        _ = try await repository.value(for: "a")
        source.failing.increment()
        var seen: [String] = []
        await #expect(throws: TestError(code: 2)) {
            for try await value in repository.updates(for: "a") { seen.append(value) }
        }
        #expect(seen == ["a#1"])
    }
}
