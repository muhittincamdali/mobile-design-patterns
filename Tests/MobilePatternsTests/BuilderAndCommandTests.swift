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

@Suite("RequestBuilder")
struct RequestBuilderTests {
    static let base = RequestBuilder(baseURL: URL(string: "https://api.example.com/v1")!)

    func error(_ builder: RequestBuilder) -> RequestBuilderError? {
        do {
            _ = try builder.build()
            return nil
        } catch {
            return error
        }
    }

    @Test func encodesSegmentsAndQueryValues() throws {
        let request = try Self.base
            .path("users", "a/b c", "orders")
            .query("q", "1+1=2 & more")
            .query("missing", nil)
            .query("emoji", "ü")
            .build()
        #expect(request.url?.absoluteString
            == "https://api.example.com/v1/users/a%2Fb%20c/orders?q=1%2B1%3D2%20%26%20more&emoji=%C3%BC")
        #expect(request.httpMethod == "GET")
        #expect(request.timeoutInterval == 60)
    }

    @Test func baseWithTrailingSlashHasNoDoubleSlash() throws {
        let request = try RequestBuilder(baseURL: URL(string: "https://api.example.com/")!).path("ping").build()
        #expect(request.url?.absoluteString == "https://api.example.com/ping")
    }

    @Test func refusesInvalidBaseURLs() {
        for base in ["ftp://example.com", "https:///path", "https://user:pw@example.com", "https://example.com?a=1",
                     "https://example.com#top", "file:///etc/hosts"] {
            #expect(error(RequestBuilder(baseURL: URL(string: base)!)) == .invalidBaseURL, "\(base)")
        }
    }

    @Test func refusesDotAndEmptySegments() {
        #expect(error(Self.base.path("..")) == .invalidPathSegment(position: 1))
        #expect(error(Self.base.path("a", ".")) == .invalidPathSegment(position: 2))
        #expect(error(Self.base.path("a").path("b", "")) == .invalidPathSegment(position: 3))
    }

    @Test func refusesHeaderInjection() {
        #expect(error(Self.base.header("X-Note", "ok\r\nSet-Cookie: a=b")) == .invalidHeaderValue)
        #expect(error(Self.base.header("X-Note", "a\nb")) == .invalidHeaderValue)
        #expect(error(Self.base.header("X-Note", "a\0b")) == .invalidHeaderValue)
        let long = String(repeating: "a", count: RequestBuilder.maxHeaderValueLength + 1)
        #expect(error(Self.base.header("X-Note", long)) == .invalidHeaderValue)
    }

    @Test func refusesInvalidHeaderNames() {
        let long = "X-" + String(repeating: "a", count: 9_000) + "\r\n"
        for name in ["", "Bad Name", "Bad:Name", "Ünicode", "a\r\nb", long] {
            #expect(error(Self.base.header(name, "1")) == .invalidHeaderName)
        }
    }

    @Test func errorsCarryNoRefusedText() {
        let value = "ok\r\nSet-Cookie: session=secret"
        let failures = [
            error(Self.base.header("Bad\r\nName: secret", "1")),
            error(Self.base.header("X-Note", value)),
            error(Self.base.path("secret", "..")),
        ]
        for failure in failures {
            #expect(failure != nil)
            #expect(!String(describing: failure).contains("secret"))
        }
    }

    @Test func headerValueErrorCarriesNoHeaderName() {
        // A valid token can be any length, so a name echoed by the error could reach a log line.
        let name = "X-secret-" + String(repeating: "a", count: 9_000)
        let failure = error(Self.base.header(name, "a\nb"))
        #expect(failure != nil)
        #expect(!String(describing: failure).contains("secret"))
        #expect(String(describing: failure).utf8.count < 100)
    }

    @Test func headerNamesReplaceWithoutCase() throws {
        let request = try Self.base.header("Accept", "text/plain").header("accept", "application/json").build()
        #expect(request.value(forHTTPHeaderField: "Accept") == "application/json")
        #expect(request.allHTTPHeaderFields?.count == 1)
    }

    @Test func jsonBodySetsContentType() throws {
        struct Payload: Codable, Equatable { let name: String }
        let request = try Self.base.method(.post).path("users").json(Payload(name: "Ada")).build()
        #expect(request.httpMethod == "POST")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(try JSONDecoder().decode(Payload.self, from: request.httpBody ?? Data()) == Payload(name: "Ada"))
    }

    @Test func bodyIsRefusedOnGetAndHead() {
        #expect(error(Self.base.body(Data([1]), contentType: "application/octet-stream")) == .bodyNotAllowed("GET"))
        #expect(error(Self.base.method(.head).body(Data(), contentType: "text/plain")) == .bodyNotAllowed("HEAD"))
    }

    @Test func timeoutMustBePositive() throws {
        #expect(error(Self.base.timeout(.zero)) == .invalidTimeout)
        #expect(error(Self.base.timeout(.seconds(-3))) == .invalidTimeout)
        #expect(try Self.base.timeout(.milliseconds(1_500)).build().timeoutInterval == 1.5)
    }
}
