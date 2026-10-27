/// A reversible change to a document: the *command* pattern.
///
/// A command knows how to apply itself and how to take itself back, so the editor can undo it
/// without storing a copy of the whole document.
public struct EditCommand<Document>: Sendable {
    /// Short name for an "Undo …" menu item or accessibility label.
    public let name: String
    let apply: @Sendable (inout Document) -> Void
    let revert: @Sendable (inout Document) -> Void

    /// Creates a command from a change and its inverse. `revert` must restore exactly what
    /// `apply` changed.
    public init(
        _ name: String,
        apply: @escaping @Sendable (inout Document) -> Void,
        revert: @escaping @Sendable (inout Document) -> Void
    ) {
        self.name = name
        self.apply = apply
        self.revert = revert
    }
}

extension EditCommand {
    /// A command that sets the value at `keyPath` and restores the old value on undo: the
    /// *memento* pattern for one property.
    public static func set<Value: Sendable>(
        _ name: String,
        _ keyPath: WritableKeyPath<Document, Value> & Sendable,
        to newValue: Value,
        from oldValue: Value
    ) -> EditCommand {
        EditCommand(name) { $0[keyPath: keyPath] = newValue } revert: { $0[keyPath: keyPath] = oldValue }
    }
}

/// A document with undo and redo history of bounded length.
///
/// ```swift
/// var editor = UndoStack(Note(title: "", body: ""), limit: 50)
/// editor.perform(.set("Rename", \.title, to: "Groceries", from: editor.document.title))
/// editor.undo()   // title is "" again
/// editor.redo()   // title is "Groceries"
/// ```
///
/// Performing a new command clears the redo history. When the history is longer than `limit`,
/// the oldest step is dropped and can no longer be undone.
public struct UndoStack<Document> {
    /// The document with every performed and not undone command applied.
    public private(set) var document: Document
    /// Most commands kept for undo.
    public let limit: Int

    private var done: [EditCommand<Document>] = []
    private var undone: [EditCommand<Document>] = []

    /// Creates an editor for `document`.
    ///
    /// - Parameters:
    ///   - document: The document before any command.
    ///   - limit: Most commands kept for undo. Values below 1 are treated as 1.
    public init(_ document: Document, limit: Int = 100) {
        self.document = document
        self.limit = max(1, limit)
    }

    /// Whether ``undo()`` has anything to take back.
    public var canUndo: Bool { !done.isEmpty }
    /// Whether ``redo()`` has anything to apply again.
    public var canRedo: Bool { !undone.isEmpty }
    /// Name of the command ``undo()`` would take back.
    public var undoName: String? { done.last?.name }
    /// Name of the command ``redo()`` would apply.
    public var redoName: String? { undone.last?.name }

    /// Applies `command`, records it for undo and clears the redo history.
    public mutating func perform(_ command: EditCommand<Document>) {
        command.apply(&document)
        done.append(command)
        if done.count > limit { done.removeFirst(done.count - limit) }
        undone.removeAll()
    }

    /// Takes back the last command. Returns `false` when there is nothing to undo.
    @discardableResult
    public mutating func undo() -> Bool {
        guard let command = done.popLast() else { return false }
        command.revert(&document)
        undone.append(command)
        return true
    }

    /// Applies the last undone command again. Returns `false` when there is nothing to redo.
    @discardableResult
    public mutating func redo() -> Bool {
        guard let command = undone.popLast() else { return false }
        command.apply(&document)
        done.append(command)
        return true
    }
}

extension UndoStack: Sendable where Document: Sendable {}
