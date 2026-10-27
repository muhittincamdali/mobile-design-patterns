/// A finite state machine whose transitions are one exhaustive `switch`: the *state* pattern
/// without a class per state.
///
/// The transition function returns the next state for a state and an event, or `nil` when the
/// event is not allowed in that state. Rejected events leave the state unchanged, so a double tap
/// on "Pay" cannot start a second payment.
///
/// ```swift
/// enum Checkout: Equatable { case cart, paying, paid, failed }
/// enum Action { case pay, succeed, fail, retry }
///
/// var machine = StateMachine<Checkout, Action>(initial: .cart) { state, action in
///     switch (state, action) {
///     case (.cart, .pay), (.failed, .retry): .paying
///     case (.paying, .succeed): .paid
///     case (.paying, .fail): .failed
///     default: nil
///     }
/// }
/// machine.send(.pay)   // Transition(from: .cart, event: .pay, to: .paying)
/// machine.send(.pay)   // nil: already paying
/// ```
public struct StateMachine<State, Event> {
    /// One accepted event: where the machine was, what happened, and where it is now.
    public struct Transition {
        public let from: State
        public let event: Event
        public let to: State
    }

    /// The current state.
    public private(set) var state: State

    private let transition: @Sendable (State, Event) -> State?

    /// Creates a machine in `initial` state.
    ///
    /// - Parameter transition: Returns the state after `event` in `state`, or `nil` when the event
    ///   is not allowed there. It must not have side effects; run them after ``send(_:)``
    ///   returns a transition.
    public init(initial: State, transition: @escaping @Sendable (State, Event) -> State?) {
        self.state = initial
        self.transition = transition
    }

    /// Applies `event` and returns the transition, or returns `nil` and keeps the state when the
    /// event is not allowed in the current state.
    @discardableResult
    public mutating func send(_ event: Event) -> Transition? {
        guard let next = transition(state, event) else { return nil }
        let accepted = Transition(from: state, event: event, to: next)
        state = next
        return accepted
    }

    /// Whether `event` would be accepted in the current state. Use it to enable or disable the
    /// button that sends the event.
    public func canSend(_ event: Event) -> Bool {
        transition(state, event) != nil
    }
}

extension StateMachine: Sendable where State: Sendable {}
extension StateMachine.Transition: Sendable where State: Sendable, Event: Sendable {}
extension StateMachine.Transition: Equatable where State: Equatable, Event: Equatable {}
