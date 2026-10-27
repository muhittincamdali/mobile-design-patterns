import Foundation
import Testing
@testable import MobilePatterns

@Suite("UndoStack")
struct UndoStackTests {
    enum Step { case undo, redo }

    /// Runs undo or redo outside `#expect`, which cannot call mutating methods.
    func step(_ editor: inout UndoStack<Note>, _ step: Step) -> Bool {
        step == .undo ? editor.undo() : editor.redo()
    }

    struct Note: Equatable, Sendable {
        var title = ""
        var tags: [String] = []
    }

    static func addTag(_ tag: String) -> EditCommand<Note> {
        EditCommand("Add \(tag)") { $0.tags.append(tag) } revert: { $0.tags.removeLast() }
    }

    @Test func undoAndRedoRestoreTheDocument() {
        var editor = UndoStack(Note())
        editor.perform(.set("Rename", \.title, to: "Groceries", from: editor.document.title))
        editor.perform(Self.addTag("home"))
        #expect(editor.document == Note(title: "Groceries", tags: ["home"]))
        #expect(editor.undoName == "Add home")

        #expect(step(&editor, .undo))
        #expect(editor.document == Note(title: "Groceries"))
        #expect(editor.redoName == "Add home")
        #expect(step(&editor, .undo))
        #expect(editor.document == Note())
        #expect(!step(&editor, .undo))

        #expect(step(&editor, .redo))
        #expect(step(&editor, .redo))
        #expect(!step(&editor, .redo))
        #expect(editor.document == Note(title: "Groceries", tags: ["home"]))
    }

    @Test func newCommandClearsRedo() {
        var editor = UndoStack(Note())
        editor.perform(Self.addTag("a"))
        editor.undo()
        #expect(editor.canRedo)
        editor.perform(Self.addTag("b"))
        #expect(!editor.canRedo)
        #expect(editor.redoName == nil)
        #expect(editor.document.tags == ["b"])
    }

    @Test func historyIsCappedAtTheLimit() {
        var editor = UndoStack(Note(), limit: 2)
        for tag in ["a", "b", "c"] { editor.perform(Self.addTag(tag)) }
        #expect(step(&editor, .undo))
        #expect(step(&editor, .undo))
        #expect(!step(&editor, .undo))
        #expect(editor.document.tags == ["a"])
        #expect(step(&editor, .redo))
        #expect(step(&editor, .redo))
        #expect(editor.document.tags == ["a", "b", "c"])
    }

    @Test func limitBelowOneKeepsOneStep() {
        var editor = UndoStack(Note(), limit: 0)
        #expect(editor.limit == 1)
        editor.perform(Self.addTag("a"))
        editor.perform(Self.addTag("b"))
        #expect(step(&editor, .undo))
        #expect(!step(&editor, .undo))
        #expect(editor.document.tags == ["a"])
    }
}
