import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_patterns/mobile_patterns.dart';

enum Checkout { cart, paying, paid, failed }

enum Action { pay, succeed, fail, retry }

StateMachine<Checkout, Action> checkout() => StateMachine(Checkout.cart, (state, action) {
  return switch ((state, action)) {
    (Checkout.cart, Action.pay) || (Checkout.failed, Action.retry) => Checkout.paying,
    (Checkout.paying, Action.succeed) => Checkout.paid,
    (Checkout.paying, Action.fail) => Checkout.failed,
    _ => null,
  };
});

EditCommand<List<String>> addTag(String tag) => EditCommand(
  'Add $tag',
  apply: (tags) => [...tags, tag],
  revert: (tags) => tags.sublist(0, tags.length - 1),
);

void main() {
  group('Loadable', () {
    test('reload and failure keep the value on screen', () {
      Loadable<int> state = const Idle();
      state = state.startLoading();
      expect(state, const Loading<int>());
      state = state.succeed(1);
      state = state.startLoading();
      expect(state, const Loading<int>(previous: 1));
      expect(state.isLoading, isTrue);
      state = state.fail('offline');
      expect(state, const Failed<int>('offline', previous: 1));
      expect(state.value, 1);
      expect(state.error, 'offline');
    });

    test('a second start while loading changes nothing', () {
      const Loadable<int> state = Loading(previous: 7);
      expect(identical(state.startLoading(), state), isTrue);
    });

    test('failure of the first load has no value', () {
      final state = const Idle<int>().startLoading().fail(StateError('x'));
      expect(state.value, isNull);
      expect(state.error, isA<StateError>());
    });
  });

  group('LoadableController', () {
    test('drops the result of a load that a newer load overtook', () async {
      final answers = [Completer<String>(), Completer<String>()];
      var call = 0;
      final controller = LoadableController(() => answers[call++].future);
      final first = controller.load();
      final second = controller.load();
      answers[1].complete('new');
      await second;
      answers[0].complete('old');
      await first;
      expect(controller.state, const Loaded('new'));
    });

    test('keeps the old value when a refresh fails', () async {
      var fail = false;
      final controller = LoadableController(
        () async => fail ? throw StateError('offline') : 'list',
      );
      await controller.load();
      fail = true;
      await controller.load();
      expect(controller.state.value, 'list');
      expect(controller.state.error, isA<StateError>());
    });

    test('ignores results that arrive after dispose', () async {
      final answer = Completer<int>();
      final controller = LoadableController(() => answer.future);
      final load = controller.load();
      controller.dispose();
      answer.complete(1);
      await expectLater(load, completes);
    });
  });

  group('StateMachine', () {
    test('refused events keep the state', () {
      final machine = checkout();
      expect(
        machine.send(Action.pay),
        const Transition(Checkout.cart, Action.pay, Checkout.paying),
      );
      expect(machine.send(Action.pay), isNull);
      expect(machine.state, Checkout.paying);
    });

    test('failure can be retried, the final state accepts nothing', () {
      final machine = checkout()
        ..send(Action.pay)
        ..send(Action.fail);
      expect(machine.canSend(Action.retry), isTrue);
      machine
        ..send(Action.retry)
        ..send(Action.succeed);
      expect(machine.state, Checkout.paid);
      expect(Action.values.where(machine.canSend), isEmpty);
    });
  });

  group('UndoStack', () {
    test('undo, redo and a new command clearing redo', () {
      final editor = UndoStack<List<String>>(const [])
        ..perform(addTag('a'))
        ..perform(addTag('b'));
      expect(editor.undoName, 'Add b');
      expect(editor.undo(), isTrue);
      expect(editor.document, ['a']);
      expect(editor.redo(), isTrue);
      expect(editor.document, ['a', 'b']);
      editor
        ..undo()
        ..perform(addTag('c'));
      expect(editor.canRedo, isFalse);
      expect(editor.document, ['a', 'c']);
    });

    test('history is capped at the limit, and a limit below one keeps one step', () {
      final editor = UndoStack<List<String>>(const [], limit: 2);
      for (final tag in ['a', 'b', 'c']) {
        editor.perform(addTag(tag));
      }
      expect([editor.undo(), editor.undo(), editor.undo()], [true, true, false]);
      expect(editor.document, ['a']);

      final tiny = UndoStack<List<String>>(const [], limit: -3);
      expect(tiny.limit, 1);
    });
  });

  testWidgets('LoadableView shows loading, then the list, then keeps it under an error', (
    tester,
  ) async {
    var answer = Completer<List<String>>();
    final controller = LoadableController(() => answer.future);
    await tester.pumpWidget(
      MaterialApp(
        home: LoadableView<List<String>>(
          controller: controller,
          loading: (_) => const Text('loading'),
          failed: (_, error) => Text('failed: $error'),
          loaded: (_, items, {required isRefreshing, error}) => Column(
            children: [
              if (isRefreshing) const Text('refreshing'),
              if (error != null) Text('banner: $error'),
              for (final item in items) Text(item),
            ],
          ),
        ),
      ),
    );
    unawaited(controller.load());
    await tester.pumpAndSettle();
    expect(find.text('loading'), findsOneWidget);

    answer.complete(['first', 'second']);
    await tester.pumpAndSettle();
    expect(find.text('second'), findsOneWidget);

    answer = Completer();
    unawaited(controller.load());
    await tester.pumpAndSettle();
    expect(find.text('refreshing'), findsOneWidget);
    expect(find.text('first'), findsOneWidget);

    answer.completeError('offline');
    await tester.pumpAndSettle();
    expect(find.text('banner: offline'), findsOneWidget);
    expect(find.text('first'), findsOneWidget);
  });
}
