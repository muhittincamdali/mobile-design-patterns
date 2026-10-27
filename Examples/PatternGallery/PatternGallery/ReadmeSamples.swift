// The code samples of the README. This file is compiled twice: by the PatternGallery app, which
// shows each pattern on screen, and by the package tests (through the symlink
// Tests/MobilePatternsTests/ReadmeSamples.swift), which run the samples.

import Foundation
import MobilePatterns
import Observation

// MARK: - Dependency injection: a client is a struct of closures

struct Article: Identifiable, Hashable, Codable, Sendable {
    let id: Int
    var title: String
    var summary: String
}

enum ArticleError: Error, Equatable {
    case offline
    case notFound
    case badResponse(status: Int)
}

/// The data source of the articles feature. Production code passes `.live(baseURL:)`, previews
/// and tests pass `.sample` or a client built from closures, with no mocking framework.
struct ArticleClient: Sendable {
    var list: @Sendable () async throws -> [Article]
    var article: @Sendable (_ id: Int) async throws -> Article
}

extension ArticleClient {
    static func live(baseURL: URL, session: URLSession = .shared) -> ArticleClient {
        let api = RequestBuilder(baseURL: baseURL).header("Accept", "application/json").timeout(.seconds(15))

        // Decorators: a time limit per attempt, two retries for server errors, one shared
        // request when several screens ask for the same article.
        let article = AsyncLoader<Int, Article> { id in
            try await get(api.path("articles", String(id)), session: session)
        }
            .timeout(.seconds(10))
            .retrying(maxAttempts: 3, delay: .milliseconds(300)) { error in
                if case ArticleError.badResponse(let status) = error { return status >= 500 }
                return error is AsyncLoaderTimeoutError
            }
            .coalescing()

        return ArticleClient(
            list: { try await get(api.path("articles"), session: session) },
            article: { id in try await article(id) }
        )
    }

    private static func get<Body: Decodable>(_ builder: RequestBuilder, session: URLSession) async throws -> Body {
        let (data, response) = try await session.data(for: try builder.build())
        let status = (response as? HTTPURLResponse)?.statusCode ?? 0
        guard (200..<300).contains(status) else {
            throw status == 404 ? ArticleError.notFound : ArticleError.badResponse(status: status)
        }
        return try JSONDecoder().decode(Body.self, from: data)
    }

    static let sampleArticles = [
        Article(id: 1, title: "View state in one enum", summary: "Loadable keeps the list on screen while it reloads."),
        Article(id: 2, title: "Coordinators for SwiftUI", summary: "A router owns the stack, so deep links push like taps."),
        Article(id: 3, title: "Undo without snapshots", summary: "Commands know how to apply and revert themselves."),
        Article(id: 4, title: "Callbacks to async/await", summary: "An adapter that survives SDKs calling back twice.")
    ]

    static let sample = ArticleClient(
        list: { sampleArticles },
        article: { id in
            guard let article = sampleArticles.first(where: { $0.id == id }) else { throw ArticleError.notFound }
            return article
        }
    )
}

// MARK: - MVVM with view state and a repository

@MainActor
@Observable
final class ArticleListModel {
    private(set) var state: Loadable<[Article], ArticleError> = .idle

    private let repository: Repository<String, [Article]>

    init(client: ArticleClient) {
        repository = Repository(capacity: 1, timeToLive: .seconds(300)) { _ in try await client.list() }
    }

    /// Shows cached articles when they are fresh, otherwise loads them.
    func load() async {
        await load(policy: .cacheFirst)
    }

    /// Pull to refresh: keeps the list on screen and replaces it when the new one arrives.
    func refresh() async {
        await load(policy: .reloadIgnoringCache)
    }

    private func load(policy: CachePolicy) async {
        state.startLoading()
        do {
            state.finish(with: .success(try await repository.value(for: "articles", policy: policy)))
        } catch {
            state.finish(with: .failure(error as? ArticleError ?? .offline))
        }
    }
}

// MARK: - Coordinator and deep links

enum AppRoute: Hashable, Sendable {
    case articles
    case article(id: Int)
    case checkout
    case editor
    case links
    case cart
}

extension DeepLinkParser where Route == AppRoute {
    /// Accepts `https://example.com/…` universal links and `patterns://…` URLs.
    static let app = DeepLinkParser(
        schemes: ["https", "patterns"],
        hosts: ["example.com"],
        patterns: [
            .init("articles") { _ in [.articles] },
            .init("articles/:id") { parameters in
                parameters.int("id").map { [.articles, .article(id: $0)] }
            },
            .init("checkout") { _ in [.checkout] },
            .init("notes") { _ in [.editor] },
            .init("links") { _ in [.links] },
            .init("cart") { _ in [.cart] }
        ]
    )
}

extension Router where Route == AppRoute {
    /// Opens a deep link. Returns `false` and keeps the stack when the link is refused.
    @discardableResult
    func open(_ url: URL) -> Bool {
        guard let routes = try? DeepLinkParser.app.routes(for: url) else { return false }
        return replaceStack(with: routes)
    }
}

// MARK: - State machine

enum CheckoutStep: Equatable, Sendable {
    case cart, paying, paid, failed
}

enum CheckoutEvent: Equatable, Sendable {
    case pay, succeed, fail, retry
}

@MainActor
@Observable
final class CheckoutModel {
    private(set) var machine = StateMachine<CheckoutStep, CheckoutEvent>(initial: .cart) { step, event in
        switch (step, event) {
        case (.cart, .pay), (.failed, .retry): .paying
        case (.paying, .succeed): .paid
        case (.paying, .fail): .failed
        default: nil
        }
    }

    private let charge: @Sendable () async throws -> Void

    init(charge: @escaping @Sendable () async throws -> Void) {
        self.charge = charge
    }

    var step: CheckoutStep { machine.state }
    var canPay: Bool { machine.canSend(.pay) || machine.canSend(.retry) }

    /// Charges once. A second tap while paying is refused by the state machine.
    func pay() async {
        guard machine.send(.pay) != nil || machine.send(.retry) != nil else { return }
        do {
            try await charge()
            machine.send(.succeed)
        } catch {
            machine.send(.fail)
        }
    }
}

// MARK: - Command and undo

struct Note: Equatable, Sendable {
    var title = ""
    var tags: [String] = []
}

extension EditCommand where Document == Note {
    static func rename(to title: String, from old: String) -> Self {
        .set("Rename", \.title, to: title, from: old)
    }

    static func addTag(_ tag: String) -> Self {
        EditCommand("Add \"\(tag)\"") { $0.tags.append(tag) } revert: { $0.tags.removeLast() }
    }
}

/// Two edits and one undo: the title stays, the tag is gone, and "Rename" is next to undo.
func editedNote() -> UndoStack<Note> {
    var editor = UndoStack(Note(), limit: 20)
    editor.perform(.rename(to: "Weekend trip", from: editor.document.title))
    editor.perform(.addTag("travel"))
    editor.undo()
    return editor
}

// MARK: - Observer

enum CartEvent: Equatable, Sendable {
    case added(itemID: Int)
    case removed(itemID: Int)
}

/// Keeps a badge count from cart events; any number of these can listen to one broadcaster.
@MainActor
@Observable
final class CartBadge {
    private(set) var count = 0

    func listen(to events: AsyncStream<CartEvent>) async {
        for await event in events {
            switch event {
            case .added: count += 1
            case .removed: count = max(0, count - 1)
            }
        }
    }
}

// MARK: - Adapter

/// A callback-based SDK, as many analytics, payment and location SDKs still are.
final class LegacyLocator: Sendable {
    private let queue = DispatchQueue(label: "LegacyLocator")
    private let city: String?

    init(city: String?) {
        self.city = city
    }

    func locate(completion: @escaping @Sendable (String?, (any Error)?) -> Void) {
        queue.async { [city] in
            if let city { completion(city, nil) } else { completion(nil, ArticleError.offline) }
        }
    }
}

extension LegacyLocator {
    func currentCity() async throws -> String {
        try await withCompletion { completion in
            locate { city, error in
                if let city { completion(.success(city)) } else { completion(.failure(error ?? ArticleError.offline)) }
            }
        }
    }
}
