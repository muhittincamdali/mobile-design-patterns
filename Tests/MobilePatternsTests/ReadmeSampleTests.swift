import Foundation
import os
import Testing
@testable import MobilePatterns

/// Runs the README samples (ReadmeSamples.swift, shared with the example app).
@Suite("README samples")
@MainActor
struct ReadmeSampleTests {
    @Test func listModelLoadsAndUsesTheCache() async {
        let calls = CallCounter()
        let model = ArticleListModel(client: ArticleClient(
            list: { calls.increment(); return ArticleClient.sampleArticles },
            article: { _ in throw ArticleError.notFound }
        ))
        #expect(model.state == .idle)
        await model.load()
        #expect(model.state == .loaded(ArticleClient.sampleArticles))
        await model.load()
        #expect(calls.count == 1)
        await model.refresh()
        #expect(calls.count == 2)
    }

    @Test func failedRefreshKeepsTheList() async {
        let calls = CallCounter()
        let model = ArticleListModel(client: ArticleClient(
            list: {
                if calls.increment() > 1 { throw URLError(.notConnectedToInternet) }
                return ArticleClient.sampleArticles
            },
            article: { _ in throw ArticleError.notFound }
        ))
        await model.load()
        await model.refresh()
        #expect(model.state == .failed(.offline, previous: ArticleClient.sampleArticles))
    }

    @Test func deepLinksReplaceTheStack() {
        let router = Router<AppRoute>(path: [.checkout])
        #expect(router.open(URL(string: "https://example.com/articles/3")!))
        #expect(router.path == [.articles, .article(id: 3)])
        #expect(router.open(URL(string: "patterns://notes")!))
        #expect(router.path == [.editor])
    }

    @Test func refusedDeepLinksKeepTheStack() {
        let router = Router<AppRoute>(path: [.articles])
        for link in ["https://evil.test/articles/1", "patterns://articles/x", "patterns://articles/%2E%2E", "mailto:a@b.c"] {
            #expect(!router.open(URL(string: link)!), "\(link)")
        }
        #expect(router.path == [.articles])
    }

    @Test func checkoutChargesOnceEvenWhenTappedTwice() async {
        let charges = CallCounter()
        let gate = Gate()
        let model = CheckoutModel {
            charges.increment()
            await gate.wait()
        }
        async let first: Void = model.pay()
        #expect(await waitUntil { charges.count == 1 })
        #expect(model.step == .paying)
        #expect(!model.canPay)
        await model.pay()
        await gate.open()
        await first
        #expect(model.step == .paid)
        #expect(charges.count == 1)
    }

    @Test func failedCheckoutCanBeRetried() async {
        let attempts = CallCounter()
        let model = CheckoutModel {
            if attempts.increment() == 1 { throw ArticleError.offline }
        }
        await model.pay()
        #expect(model.step == .failed)
        #expect(model.canPay)
        await model.pay()
        #expect(model.step == .paid)
    }

    @Test func noteEditorUndoesTagsAndTitle() {
        var editor = UndoStack(Note())
        editor.perform(.rename(to: "Trip", from: editor.document.title))
        editor.perform(.addTag("travel"))
        editor.undo()
        #expect(editor.document == Note(title: "Trip"))
        editor.undo()
        #expect(editor.document == Note())
    }

    @Test func cartBadgeFollowsTheBroadcast() async {
        let events = Broadcaster<CartEvent>()
        let badge = CartBadge()
        let stream = events.events()
        events.send(.added(itemID: 1))
        events.send(.added(itemID: 2))
        events.send(.removed(itemID: 1))
        events.send(.removed(itemID: 2))
        events.send(.removed(itemID: 3))
        events.send(.added(itemID: 4))
        events.finish()
        await badge.listen(to: stream)
        #expect(badge.count == 1)
    }

    @Test func legacyCallbackBecomesAsync() async throws {
        #expect(try await LegacyLocator(city: "İzmir").currentCity() == "İzmir")
        await #expect(throws: ArticleError.offline) { try await LegacyLocator(city: nil).currentCity() }
    }

    @Test func liveClientRetriesServerErrorsOnly() async throws {
        let session = StubProtocol.session { request, attempt in
            switch (request.url?.path, attempt) {
            case ("/v1/articles/2", 1), ("/v1/articles/2", 2): (500, Data())
            case ("/v1/articles/2", _): (200, Data(#"{"id":2,"title":"T","summary":"S"}"#.utf8))
            default: (404, Data())
            }
        }
        let client = ArticleClient.live(baseURL: URL(string: "https://api.example.com/v1")!, session: session)
        #expect(try await client.article(2) == Article(id: 2, title: "T", summary: "S"))
        #expect(StubProtocol.requests(for: "/v1/articles/2") == 3)
        await #expect(throws: ArticleError.notFound) { try await client.article(9) }
        #expect(StubProtocol.requests(for: "/v1/articles/9") == 1)
    }
}

/// Answers requests of a `URLSession` from a closure, counting attempts per path.
final class StubProtocol: URLProtocol {
    typealias Handler = @Sendable (URLRequest, Int) -> (Int, Data)

    private static let state = OSAllocatedUnfairLock(initialState: (handler: Handler?.none, counts: [String: Int]()))

    static func session(_ handler: @escaping Handler) -> URLSession {
        state.withLock { $0 = (handler, [:]) }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubProtocol.self]
        return URLSession(configuration: configuration)
    }

    static func requests(for path: String) -> Int {
        state.withLock { $0.counts[path, default: 0] }
    }

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        let path = request.url?.path ?? ""
        let (handler, attempt) = Self.state.withLock { state in
            state.counts[path, default: 0] += 1
            return (state.handler, state.counts[path, default: 0])
        }
        let (status, body) = handler?(request, attempt) ?? (500, Data())
        let response = HTTPURLResponse(url: request.url!, statusCode: status, httpVersion: "HTTP/1.1", headerFields: nil)!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: body)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
