import MobilePatterns
import os
import SwiftUI

/// A switch the demo clients read from any task.
final class DemoFlag: Sendable {
    private let value = OSAllocatedUnfairLock(initialState: false)

    var isOn: Bool {
        get { value.withLock { $0 } }
        set { value.withLock { $0 = newValue } }
    }
}

extension ArticleClient {
    /// The sample client with a short delay, and failures on demand.
    static func demo(failing: DemoFlag) -> ArticleClient {
        ArticleClient(
            list: {
                try await Task.sleep(for: .milliseconds(600))
                if failing.isOn { throw ArticleError.offline }
                return try await sample.list()
            },
            article: { id in
                try await Task.sleep(for: .milliseconds(300))
                return try await sample.article(id)
            }
        )
    }
}

// MARK: - View state, MVVM and repository

struct ArticlesScreen: View {
    @State private var failing: DemoFlag
    @State private var model: ArticleListModel

    init() {
        let flag = DemoFlag()
        _failing = State(initialValue: flag)
        _model = State(initialValue: ArticleListModel(client: .demo(failing: flag)))
    }

    var body: some View {
        List {
            Section {
                Toggle("Fail the next refresh", isOn: Binding(get: { failing.isOn }, set: { failing.isOn = $0 }))
                StateBadge(state: model.state)
            }
            if let failure = model.state.failure {
                Section {
                    Label("Refresh failed (\(String(describing: failure))). Showing the last list.", systemImage: "wifi.exclamationmark")
                        .foregroundStyle(.orange)
                }
            }
            Section("Articles") {
                if let articles = model.state.value {
                    ForEach(articles) { article in
                        NavigationLink(value: AppRoute.article(id: article.id)) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(article.title).font(.headline)
                                Text(article.summary).font(.subheadline).foregroundStyle(.secondary)
                            }
                        }
                    }
                } else if model.state.isLoading {
                    ProgressView()
                }
            }
        }
        .navigationTitle("View state")
        .refreshable { await model.refresh() }
        .toolbar {
            Button("Refresh", systemImage: "arrow.clockwise") { Task { await model.refresh() } }
                .disabled(model.state.isLoading)
        }
        .task { await model.load() }
    }
}

struct StateBadge: View {
    let state: Loadable<[Article], ArticleError>

    var body: some View {
        LabeledContent("State") {
            Text(description).font(.body.monospaced()).foregroundStyle(.blue)
        }
    }

    private var description: String {
        switch state {
        case .idle: ".idle"
        case .loading(let previous): ".loading(previous: \(previous.map { "\($0.count) items" } ?? "nil"))"
        case .loaded(let value): ".loaded(\(value.count) items)"
        case .failed(let failure, let previous): ".failed(.\(failure), previous: \(previous.map { "\($0.count) items" } ?? "nil"))"
        }
    }
}

struct ArticleDetailScreen: View {
    let id: Int
    @State private var state: Loadable<Article, ArticleError> = .idle

    var body: some View {
        Group {
            if let article = state.value {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(article.title).font(.title.bold())
                        Text(article.summary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                }
            } else if let failure = state.failure {
                ContentUnavailableView("Not found", systemImage: "doc.questionmark", description: Text(String(describing: failure)))
            } else {
                ProgressView()
            }
        }
        .navigationTitle("Article \(id)")
        .task {
            state.startLoading()
            do {
                state.finish(with: .success(try await ArticleClient.demo(failing: DemoFlag()).article(id)))
            } catch {
                state.finish(with: .failure(error as? ArticleError ?? .offline))
            }
        }
    }
}

// MARK: - State machine

struct CheckoutScreen: View {
    @State private var decline: DemoFlag
    @State private var model: CheckoutModel

    init() {
        let flag = DemoFlag()
        _decline = State(initialValue: flag)
        _model = State(initialValue: CheckoutModel {
            try await Task.sleep(for: .seconds(1))
            if flag.isOn { throw ArticleError.offline }
        })
    }

    var body: some View {
        List {
            Section("Steps") {
                ForEach([CheckoutStep.cart, .paying, .paid, .failed], id: \.self) { step in
                    HStack {
                        Image(systemName: step == model.step ? "largecircle.fill.circle" : "circle")
                            .foregroundStyle(.blue)
                        Text(String(describing: step))
                        Spacer()
                        if step == .paying && model.step == .paying { ProgressView() }
                    }
                }
            }
            Section {
                Toggle("Decline the card", isOn: Binding(get: { decline.isOn }, set: { decline.isOn = $0 }))
                Button(model.step == .failed ? "Retry payment" : "Pay 24.90") {
                    Task { await model.pay() }
                }
                .disabled(!model.canPay)
            } footer: {
                Text("While paying, the machine refuses .pay, so a double tap charges once.")
            }
        }
        .navigationTitle("State machine")
    }
}

// MARK: - Command and undo

struct NotesScreen: View {
    @State private var editor: UndoStack<Note> = {
        var editor = UndoStack(Note(), limit: 20)
        editor.perform(.rename(to: "Weekend trip", from: ""))
        editor.perform(.addTag("travel"))
        editor.perform(.addTag("family"))
        return editor
    }()
    @State private var newTag = ""

    var body: some View {
        List {
            Section("Note") {
                LabeledContent("Title", value: editor.document.title)
                LabeledContent("Tags", value: editor.document.tags.isEmpty ? "none" : editor.document.tags.joined(separator: ", "))
            }
            Section("Add a tag") {
                HStack {
                    TextField("Tag", text: $newTag)
                    Button("Add") {
                        editor.perform(.addTag(newTag))
                        newTag = ""
                    }
                    .disabled(newTag.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            Section {
                Button(editor.undoName.map { "Undo \($0)" } ?? "Nothing to undo", systemImage: "arrow.uturn.backward") {
                    editor.undo()
                }
                .disabled(!editor.canUndo)
                Button(editor.redoName.map { "Redo \($0)" } ?? "Nothing to redo", systemImage: "arrow.uturn.forward") {
                    editor.redo()
                }
                .disabled(!editor.canRedo)
            } footer: {
                Text("History keeps the last \(editor.limit) commands.")
            }
        }
        .navigationTitle("Command and undo")
    }
}

// MARK: - Observer

struct CartScreen: View {
    @State private var events = Broadcaster<CartEvent>()
    @State private var badge = CartBadge()
    @State private var log: [String] = []
    @State private var nextItem = 1

    var body: some View {
        List {
            Section("Subscriber 1: badge") {
                LabeledContent("Items in cart", value: "\(badge.count)")
            }
            Section("Subscriber 2: event log") {
                if log.isEmpty { Text("No events yet").foregroundStyle(.secondary) }
                ForEach(Array(log.suffix(5).enumerated()), id: \.offset) { _, line in
                    Text(line).font(.body.monospaced())
                }
            }
            Section {
                Button("Add item", systemImage: "cart.badge.plus") {
                    events.send(.added(itemID: nextItem))
                    nextItem += 1
                }
                Button("Remove item", systemImage: "cart.badge.minus") {
                    events.send(.removed(itemID: nextItem - 1))
                }
                .disabled(badge.count == 0)
            } footer: {
                Text("The badge and the log each read their own stream from one Broadcaster.")
            }
        }
        .navigationTitle("Observer")
        .task { await badge.listen(to: events.events()) }
        .task {
            for await event in events.events() {
                log.append(String(describing: event))
            }
        }
    }
}

// MARK: - Coordinator and deep links

struct DeepLinksScreen: View {
    @Environment(Router<AppRoute>.self) private var router
    @State private var lastResult = "Tap a link"

    private let links = [
        "patterns://articles/2",
        "https://example.com/checkout",
        "https://example.com/articles/abc",
        "https://example.com.evil.test/articles/1",
        "https://user:secret@example.com/articles",
        "patterns://articles/%2E%2E"
    ]

    var body: some View {
        List {
            Section("Links") {
                ForEach(links, id: \.self) { link in
                    Button(link) { open(link) }
                        .font(.footnote.monospaced())
                }
            }
            Section("Result") {
                Text(lastResult).font(.footnote.monospaced())
            }
        }
        .navigationTitle("Deep links")
    }

    private func open(_ link: String) {
        guard let url = URL(string: link) else { return }
        do {
            let routes = try DeepLinkParser.app.routes(for: url)
            lastResult = "Opened \(routes)"
            router.replaceStack(with: routes)
        } catch {
            lastResult = "Refused: \(error)"
        }
    }
}
