# Command Pattern

> Encapsulate request as an object

## Problem

- Need undo/redo functionality
- Queue or log operations
- Decouple invoker from receiver
- Support macro commands

## Solution

```swift
// MARK: - Command Protocol
protocol Command {
    func execute()
    func undo()
    var description: String { get }
}

// MARK: - Receiver
class TextEditor {
    private(set) var text: String = ""
    private(set) var cursorPosition: Int = 0
    
    func insert(_ string: String, at position: Int) {
        let index = text.index(text.startIndex, offsetBy: position)
        text.insert(contentsOf: string, at: index)
        cursorPosition = position + string.count
    }
    
    func delete(at position: Int, length: Int) {
        let startIndex = text.index(text.startIndex, offsetBy: position)
        let endIndex = text.index(startIndex, offsetBy: length)
        text.removeSubrange(startIndex..<endIndex)
        cursorPosition = position
    }
}

// MARK: - Concrete Commands
class InsertTextCommand: Command {
    private let editor: TextEditor
    private let text: String
    private let position: Int
    
    var description: String { "Insert '\(text)'" }
    
    init(editor: TextEditor, text: String, position: Int) {
        self.editor = editor
        self.text = text
        self.position = position
    }
    
    func execute() {
        editor.insert(text, at: position)
    }
    
    func undo() {
        editor.delete(at: position, length: text.count)
    }
}

class DeleteTextCommand: Command {
    private let editor: TextEditor
    private let position: Int
    private let length: Int
    private var deletedText: String = ""
    
    var description: String { "Delete \(length) chars" }
    
    init(editor: TextEditor, position: Int, length: Int) {
        self.editor = editor
        self.position = position
        self.length = length
    }
    
    func execute() {
        let startIndex = editor.text.index(editor.text.startIndex, offsetBy: position)
        let endIndex = editor.text.index(startIndex, offsetBy: length)
        deletedText = String(editor.text[startIndex..<endIndex])
        editor.delete(at: position, length: length)
    }
    
    func undo() {
        editor.insert(deletedText, at: position)
    }
}

class BoldTextCommand: Command {
    private let editor: TextEditor
    private let range: Range<Int>
    
    var description: String { "Bold selection" }
    
    init(editor: TextEditor, range: Range<Int>) {
        self.editor = editor
        self.range = range
    }
    
    func execute() {
        editor.insert("**", at: range.upperBound)
        editor.insert("**", at: range.lowerBound)
    }
    
    func undo() {
        editor.delete(at: range.upperBound + 2, length: 2)
        editor.delete(at: range.lowerBound, length: 2)
    }
}

// MARK: - Macro Command (Composite)
class MacroCommand: Command {
    private var commands: [Command] = []
    let description: String
    
    init(description: String) {
        self.description = description
    }
    
    func add(_ command: Command) {
        commands.append(command)
    }
    
    func execute() {
        commands.forEach { $0.execute() }
    }
    
    func undo() {
        commands.reversed().forEach { $0.undo() }
    }
}

// MARK: - Invoker (Command Manager)
class CommandManager {
    private var history: [Command] = []
    private var redoStack: [Command] = []
    private let maxHistory: Int
    
    init(maxHistory: Int = 100) {
        self.maxHistory = maxHistory
    }
    
    func execute(_ command: Command) {
        command.execute()
        history.append(command)
        redoStack.removeAll()
        
        if history.count > maxHistory {
            history.removeFirst()
        }
    }
    
    func undo() {
        guard let command = history.popLast() else { return }
        command.undo()
        redoStack.append(command)
    }
    
    func redo() {
        guard let command = redoStack.popLast() else { return }
        command.execute()
        history.append(command)
    }
    
    var canUndo: Bool { !history.isEmpty }
    var canRedo: Bool { !redoStack.isEmpty }
    
    var historyDescription: [String] {
        history.map { $0.description }
    }
}

// MARK: - Usage
let editor = TextEditor()
let commandManager = CommandManager()

// Execute commands
commandManager.execute(InsertTextCommand(editor: editor, text: "Hello", position: 0))
commandManager.execute(InsertTextCommand(editor: editor, text: " World", position: 5))
print(editor.text) // "Hello World"

// Undo
commandManager.undo()
print(editor.text) // "Hello"

// Redo
commandManager.redo()
print(editor.text) // "Hello World"

// Macro command
let formatMacro = MacroCommand(description: "Format text")
formatMacro.add(BoldTextCommand(editor: editor, range: 0..<5))
formatMacro.add(InsertTextCommand(editor: editor, text: "\n", position: editor.text.count))
commandManager.execute(formatMacro)
```

## Async Command

```swift
protocol AsyncCommand {
    func execute() async throws
    func undo() async throws
}

class APIRequestCommand: AsyncCommand {
    private let request: URLRequest
    private var response: Data?
    
    init(request: URLRequest) {
        self.request = request
    }
    
    func execute() async throws {
        let (data, _) = try await URLSession.shared.data(for: request)
        response = data
    }
    
    func undo() async throws {
        response = nil
    }
}

class AsyncCommandQueue {
    private var queue: [AsyncCommand] = []
    private var isExecuting = false
    
    func enqueue(_ command: AsyncCommand) {
        queue.append(command)
        processQueue()
    }
    
    private func processQueue() {
        guard !isExecuting, !queue.isEmpty else { return }
        isExecuting = true
        
        Task {
            while !queue.isEmpty {
                let command = queue.removeFirst()
                do {
                    try await command.execute()
                } catch {
                    print("Command failed: \(error)")
                }
            }
            isExecuting = false
        }
    }
}
```

## When to Use ✅

- Implement undo/redo
- Queue operations
- Schedule execution
- Support transactions
- Logging operations

## When NOT to Use ❌

- Simple operations without undo
- Fire-and-forget actions
- No need for operation history

## Related Patterns

- **Memento**: Alternative for undo (save state)
- **Strategy**: Different approach to algorithms
- **Composite**: Group commands into macros
