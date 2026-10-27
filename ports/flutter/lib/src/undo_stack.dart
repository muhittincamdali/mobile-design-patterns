/// A reversible change to an immutable document: the command pattern.
final class EditCommand<D> {
  /// Creates a command from a change and its inverse.
  const EditCommand(this.name, {required this.apply, required this.revert});

  /// Short name for an "Undo …" label.
  final String name;

  /// Returns the document with the change applied.
  final D Function(D document) apply;

  /// Returns the document with the change taken back.
  final D Function(D document) revert;
}

/// A document with undo and redo history of bounded length.
///
/// A new command clears the redo history. Beyond [limit] steps the oldest one is dropped.
class UndoStack<D> {
  /// Creates an editor for [document]. A [limit] below 1 is treated as 1.
  UndoStack(D document, {int limit = 100}) : _document = document, limit = limit < 1 ? 1 : limit;

  /// Most commands kept for undo.
  final int limit;

  D _document;
  final List<EditCommand<D>> _done = [];
  final List<EditCommand<D>> _undone = [];

  /// The document with every performed and not undone command applied.
  D get document => _document;

  /// Whether [undo] has anything to take back.
  bool get canUndo => _done.isNotEmpty;

  /// Whether [redo] has anything to apply again.
  bool get canRedo => _undone.isNotEmpty;

  /// Name of the command [undo] would take back.
  String? get undoName => _done.isEmpty ? null : _done.last.name;

  /// Name of the command [redo] would apply.
  String? get redoName => _undone.isEmpty ? null : _undone.last.name;

  /// Applies [command], records it and clears the redo history.
  void perform(EditCommand<D> command) {
    _document = command.apply(_document);
    _done.add(command);
    if (_done.length > limit) _done.removeRange(0, _done.length - limit);
    _undone.clear();
  }

  /// Takes back the last command. Returns `false` when there is nothing to undo.
  bool undo() {
    if (_done.isEmpty) return false;
    final command = _done.removeLast();
    _document = command.revert(_document);
    _undone.add(command);
    return true;
  }

  /// Applies the last undone command again. Returns `false` when there is nothing to redo.
  bool redo() {
    if (_undone.isEmpty) return false;
    final command = _undone.removeLast();
    _document = command.apply(_document);
    _done.add(command);
    return true;
  }
}
