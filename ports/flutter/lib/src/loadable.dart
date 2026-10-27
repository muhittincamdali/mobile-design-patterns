/// The state of a value that a screen loads asynchronously: the view state pattern.
///
/// One sealed class replaces separate `isLoading`, `error` and `data` fields, so a screen is
/// never loading and failed at the same time. A reload or a failure keeps the value that is on
/// screen in `previous`.
sealed class Loadable<T> {
  const Loadable();

  /// The newest value in any state: the loaded value, or the one kept from an earlier load.
  T? get value;

  /// Whether a load is running.
  bool get isLoading => this is Loading<T>;

  /// The error of the last load when it failed, otherwise `null`.
  Object? get error => switch (this) {
    Failed<T>(:final error) => error,
    _ => null,
  };

  /// Moves to [Loading] and keeps the current [value]. Returns this state unchanged when a
  /// load is already running.
  Loadable<T> startLoading() => isLoading ? this : Loading<T>(previous: value);

  /// Moves to [Loaded].
  Loadable<T> succeed(T value) => Loaded<T>(value);

  /// Moves to [Failed] and keeps the current [value].
  Loadable<T> fail(Object error) => Failed<T>(error, previous: value);
}

/// Nothing has been requested yet.
final class Idle<T> extends Loadable<T> {
  /// Creates the idle state.
  const Idle();

  @override
  T? get value => null;

  @override
  bool operator ==(Object other) => other is Idle<T>;

  @override
  int get hashCode => (Idle<T>).hashCode;

  @override
  String toString() => 'Idle()';
}

/// A load is running; [previous] is the value of an earlier load, if any.
final class Loading<T> extends Loadable<T> {
  /// Creates the loading state.
  const Loading({this.previous});

  /// The value of an earlier load.
  final T? previous;

  @override
  T? get value => previous;

  @override
  bool operator ==(Object other) => other is Loading<T> && other.previous == previous;

  @override
  int get hashCode => Object.hash(Loading<T>, previous);

  @override
  String toString() => 'Loading(previous: $previous)';
}

/// The last load succeeded.
final class Loaded<T> extends Loadable<T> {
  /// Creates the loaded state.
  const Loaded(this.loaded);

  /// The loaded value.
  final T loaded;

  @override
  T? get value => loaded;

  @override
  bool operator ==(Object other) => other is Loaded<T> && other.loaded == loaded;

  @override
  int get hashCode => Object.hash(Loaded<T>, loaded);

  @override
  String toString() => 'Loaded($loaded)';
}

/// The last load failed; [previous] is the value of an earlier load, if any.
final class Failed<T> extends Loadable<T> {
  /// Creates the failed state.
  const Failed(this.error, {this.previous});

  @override
  final Object error;

  /// The value of an earlier load.
  final T? previous;

  @override
  T? get value => previous;

  @override
  bool operator ==(Object other) =>
      other is Failed<T> && other.error == error && other.previous == previous;

  @override
  int get hashCode => Object.hash(Failed<T>, error, previous);

  @override
  String toString() => 'Failed($error, previous: $previous)';
}
