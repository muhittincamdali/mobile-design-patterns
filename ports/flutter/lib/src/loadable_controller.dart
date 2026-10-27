import 'package:flutter/widgets.dart';

import 'loadable.dart';

/// Holds a [Loadable] for one screen and runs its loads: the view model of MVVM.
///
/// Only the newest load may change the state: when a refresh starts while an older load is
/// still running, the older result is dropped. Results that arrive after [dispose] are dropped
/// too, so a screen that was closed during a load does not throw.
class LoadableController<T> extends ChangeNotifier {
  /// Creates a controller that loads with [fetch].
  LoadableController(this._fetch);

  final Future<T> Function() _fetch;
  Loadable<T> _state = Idle<T>();
  int _generation = 0;
  bool _disposed = false;

  /// The current state.
  Loadable<T> get state => _state;

  /// Loads the value and keeps the current one on screen while it runs.
  Future<void> load() async {
    final generation = ++_generation;
    _set(_state.startLoading());
    try {
      final value = await _fetch();
      if (generation == _generation) _set(_state.succeed(value));
    } catch (error) {
      if (generation == _generation) _set(_state.fail(error));
    }
  }

  void _set(Loadable<T> next) {
    if (_disposed || next == _state) return;
    _state = next;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

/// Builds a widget for each state of a [LoadableController].
///
/// While a reload runs or after it failed, [loaded] still gets the previous value, with
/// `isRefreshing` or `error` set, so a list stays on screen under a progress bar or a banner.
class LoadableView<T> extends StatelessWidget {
  /// Creates the view.
  const LoadableView({
    super.key,
    required this.controller,
    required this.loading,
    required this.loaded,
    required this.failed,
  });

  /// The controller to listen to.
  final LoadableController<T> controller;

  /// Shown while nothing has loaded yet.
  final WidgetBuilder loading;

  /// Shown whenever a value is available.
  final Widget Function(BuildContext context, T value, {required bool isRefreshing, Object? error})
  loaded;

  /// Shown when the first load failed.
  final Widget Function(BuildContext context, Object error) failed;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final state = controller.state;
        final value = state.value;
        if (value != null) {
          return loaded(context, value, isRefreshing: state.isLoading, error: state.error);
        }
        return switch (state) {
          Failed<T>(:final error) => failed(context, error),
          _ => loading(context),
        };
      },
    );
  }
}
