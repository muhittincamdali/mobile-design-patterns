import Testing
@testable import MobilePatterns

@Suite("Loadable")
struct LoadableTests {
    enum Failure: Error, Equatable { case offline }

    @Test func firstLoadHasNoPreviousValue() {
        var state = Loadable<[Int], Failure>.idle
        state.startLoading()
        #expect(state == .loading(previous: nil))
        #expect(state.isLoading)
        #expect(state.value == nil)
    }

    @Test func reloadKeepsTheValueOnScreen() {
        var state = Loadable<[Int], Failure>.loaded([1, 2])
        state.startLoading()
        #expect(state == .loading(previous: [1, 2]))
        #expect(state.value == [1, 2])
    }

    @Test func failureKeepsTheEarlierValue() {
        var state = Loadable<[Int], Failure>.loaded([1])
        state.startLoading()
        state.finish(with: .failure(.offline))
        #expect(state == .failed(.offline, previous: [1]))
        #expect(state.failure == .offline)
        #expect(!state.isLoading)
        #expect(state.value == [1])
    }

    @Test func retryAfterFailureStillKeepsTheValue() {
        var state = Loadable<[Int], Failure>.failed(.offline, previous: [3])
        state.startLoading()
        #expect(state == .loading(previous: [3]))
        state.finish(with: .success([4]))
        #expect(state == .loaded([4]))
        #expect(state.failure == nil)
    }

    @Test func secondStartWhileLoadingChangesNothing() {
        var state = Loadable<Int, Failure>.loading(previous: 7)
        state.startLoading()
        #expect(state == .loading(previous: 7))
    }

    @Test func failureOfFirstLoadHasNoValue() {
        var state = Loadable<Int, Failure>.idle
        state.startLoading()
        state.finish(with: .failure(.offline))
        #expect(state == .failed(.offline, previous: nil))
        #expect(state.value == nil)
    }

    @Test func mapTransformsTheValueInEveryState() {
        #expect(Loadable<Int, Failure>.idle.map(String.init) == .idle)
        #expect(Loadable<Int, Failure>.loading(previous: 1).map(String.init) == .loading(previous: "1"))
        #expect(Loadable<Int, Failure>.loading(previous: nil).map(String.init) == .loading(previous: nil))
        #expect(Loadable<Int, Failure>.loaded(2).map(String.init) == .loaded("2"))
        #expect(Loadable<Int, Failure>.failed(.offline, previous: 3).map(String.init) == .failed(.offline, previous: "3"))
    }
}

@Suite("StateMachine")
struct StateMachineTests {
    enum Checkout: Equatable, Sendable { case cart, paying, paid, failed }
    enum Action: Equatable, Sendable { case pay, succeed, fail, retry }

    static func checkout() -> StateMachine<Checkout, Action> {
        StateMachine(initial: .cart) { state, action in
            switch (state, action) {
            case (.cart, .pay), (.failed, .retry): .paying
            case (.paying, .succeed): .paid
            case (.paying, .fail): .failed
            default: nil
            }
        }
    }

    @Test func acceptedEventReturnsTheTransition() {
        var machine = Self.checkout()
        let transition = machine.send(.pay)
        #expect(transition == .init(from: .cart, event: .pay, to: .paying))
        #expect(machine.state == .paying)
    }

    @Test func rejectedEventKeepsTheState() {
        var machine = Self.checkout()
        machine.send(.pay)
        #expect(machine.send(.pay) == nil)
        #expect(machine.send(.retry) == nil)
        #expect(machine.state == .paying)
    }

    @Test func failureAndRetryPath() {
        var machine = Self.checkout()
        machine.send(.pay)
        machine.send(.fail)
        #expect(machine.state == .failed)
        #expect(machine.canSend(.retry))
        #expect(!machine.canSend(.succeed))
        machine.send(.retry)
        machine.send(.succeed)
        #expect(machine.state == .paid)
    }

    @Test func finalStateAcceptsNothing() {
        var machine = Self.checkout()
        machine.send(.pay)
        machine.send(.succeed)
        for action in [Action.pay, .succeed, .fail, .retry] {
            #expect(!machine.canSend(action))
            #expect(machine.send(action) == nil)
        }
        #expect(machine.state == .paid)
    }
}
