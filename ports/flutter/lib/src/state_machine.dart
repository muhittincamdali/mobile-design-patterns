/// One accepted event of a [StateMachine].
final class Transition<S, E> {
  /// Creates a transition.
  const Transition(this.from, this.event, this.to);

  /// The state before the event.
  final S from;

  /// The accepted event.
  final E event;

  /// The state after the event.
  final S to;

  @override
  bool operator ==(Object other) =>
      other is Transition<S, E> && other.from == from && other.event == event && other.to == to;

  @override
  int get hashCode => Object.hash(from, event, to);

  @override
  String toString() => 'Transition($from --$event--> $to)';
}

/// A finite state machine whose transitions are one function: the state pattern.
///
/// The function returns the next state, or `null` when the event is not allowed in the current
/// state; refused events keep the state.
class StateMachine<S, E> {
  /// Creates a machine in [initial] state.
  StateMachine(S initial, this._transition) : _state = initial;

  final S? Function(S state, E event) _transition;
  S _state;

  /// The current state.
  S get state => _state;

  /// Applies [event] and returns the transition, or returns `null` when it is not allowed.
  Transition<S, E>? send(E event) {
    final next = _transition(_state, event);
    if (next == null) return null;
    final transition = Transition(_state, event, next);
    _state = next;
    return transition;
  }

  /// Whether [event] would be accepted now.
  bool canSend(E event) => _transition(_state, event) != null;
}
