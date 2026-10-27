import Foundation
import Testing
@testable import MobilePatterns

@Suite("Router")
@MainActor
struct RouterTests {
    enum Route: Hashable { case list, detail(Int), settings }

    @Test func pushAndPop() {
        let router = Router<Route>()
        router.push(.list)
        router.push(.detail(1))
        #expect(router.top == .detail(1))
        router.pop()
        #expect(router.path == [.list])
        router.popToRoot()
        #expect(router.path.isEmpty)
        #expect(router.top == nil)
    }

    @Test func popMoreThanTheStackEmptiesIt() {
        let router = Router<Route>(path: [.list, .detail(1)])
        router.pop(5)
        #expect(router.path.isEmpty)
    }

    @Test func popWithZeroOrNegativeCountDoesNothing() {
        let router = Router<Route>(path: [.list])
        router.pop(0)
        router.pop(-3)
        #expect(router.path == [.list])
    }

    @Test func pushStopsAtMaxDepth() {
        let router = Router<Route>(maxDepth: 2)
        #expect(router.push(.list))
        #expect(router.push(.detail(1)))
        #expect(!router.push(.detail(2)))
        #expect(router.path == [.list, .detail(1)])
    }

    @Test func initialPathIsCutToMaxDepth() {
        let router = Router<Route>(path: [.list, .detail(1), .detail(2)], maxDepth: 2)
        #expect(router.path == [.list, .detail(1)])
    }

    @Test func maxDepthBelowOneBecomesOne() {
        let router = Router<Route>(maxDepth: -4)
        #expect(router.maxDepth == 1)
        #expect(router.push(.list))
        #expect(!router.push(.settings))
    }

    @Test func popToRouteKeepsItOnTop() {
        let router = Router<Route>(path: [.list, .detail(1), .settings, .detail(2)])
        #expect(router.pop(to: .detail(1)))
        #expect(router.path == [.list, .detail(1)])
        #expect(!router.pop(to: .detail(9)))
        #expect(router.path == [.list, .detail(1)])
    }

    @Test func replaceStackRefusesTooDeepStacks() {
        let router = Router<Route>(path: [.settings], maxDepth: 2)
        #expect(!router.replaceStack(with: [.list, .detail(1), .detail(2)]))
        #expect(router.path == [.settings])
        #expect(router.replaceStack(with: [.list, .detail(3)]))
        #expect(router.path == [.list, .detail(3)])
    }
}

@Suite("DeepLinkParser")
struct DeepLinkParserTests {
    enum Route: Equatable, Sendable { case articles, article(Int), search(String), profile(String) }

    static let parser = DeepLinkParser<Route>(
        schemes: ["HTTPS", "patterns"],
        hosts: ["Example.com"],
        limits: .init(maxURLLength: 200, maxSegments: 4, maxValueLength: 20, maxQueryItems: 3),
        patterns: [
            .init("articles") { _ in [.articles] },
            .init("articles/:id") { parameters in
                parameters.int("id").map { [.articles, .article($0)] }
            },
            .init("search") { parameters in
                parameters["q"].map { [.search($0)] }
            },
            .init("users/:name") { parameters in
                [.profile(parameters["name"] ?? "")]
            },
            .init("users/me") { _ in [.profile("never reached")] }
        ]
    )

    func routes(_ string: String) throws(DeepLinkError) -> [Route] {
        try Self.parser.routes(for: URL(string: string)!)
    }

    func error(_ string: String) -> DeepLinkError? {
        do {
            _ = try routes(string)
            return nil
        } catch {
            return error
        }
    }

    @Test func universalLinkOpensTheWholeStack() throws {
        #expect(try routes("https://example.com/articles/42") == [.articles, .article(42)])
    }

    @Test func schemeAndHostAreComparedWithoutCase() throws {
        #expect(try routes("HTTPS://EXAMPLE.COM/articles") == [.articles])
    }

    @Test func customSchemeReadsTheHostAsFirstSegment() throws {
        #expect(try routes("patterns://articles/7") == [.articles, .article(7)])
        #expect(try routes("patterns:///articles/7") == [.articles, .article(7)])
    }

    @Test func queryAndPercentEncodingAreDecoded() throws {
        #expect(try routes("patterns://search?q=swift%20ui&q=second") == [.search("swift ui")])
        #expect(try routes("https://example.com/users/ay%C5%9Fe") == [.profile("ayşe")])
    }

    @Test func firstMatchingPatternWins() throws {
        #expect(try routes("patterns://users/me") == [.profile("me")])
    }

    @Test func unknownSchemesAndHostsAreRefused() {
        #expect(error("javascript://articles") == .unsupportedScheme)
        #expect(error("http://example.com/articles") == .unsupportedScheme)
        #expect(error("https://example.com.evil.test/articles") == .unknownHost)
        #expect(error("https:/articles") == .unknownHost)
    }

    @Test func credentialsAreRefused() {
        #expect(error("https://user:secret@example.com/articles") == .credentialsNotAllowed)
        #expect(error("https://user@example.com/articles") == .credentialsNotAllowed)
    }

    @Test func dotSegmentsAreRefusedEvenWhenEncoded() {
        #expect(error("https://example.com/articles/../users/me") == .malformedPath)
        #expect(error("https://example.com/articles/%2E%2E") == .malformedPath)
        #expect(error("https://example.com/./articles") == .malformedPath)
    }

    @Test func invalidPercentEncodingIsRefused() {
        #expect(error("https://example.com/users/%FF") == .malformedPath)
    }

    @Test func controlCharactersAreRefused() {
        #expect(error("https://example.com/users/a%0Ab") == .invalidValue("segment 2"))
        #expect(error("patterns://search?q=a%00b") == .invalidValue("query item 1"))
        #expect(error("patterns://search?q=1&na%0Ame=1") == .invalidValue("query item 2"))
    }

    @Test func errorsCarryNoTextFromTheURL() {
        let secret = "secret-token-abc123"
        let urls = [
            "https://\(secret).test/articles",
            "\(secret)://articles",
            "https://example.com/users/\(secret)%0A",
            "patterns://search?q=\(secret)%00",
            "patterns://search?\(secret)%0A=1",
        ]
        for url in urls {
            let failure = error(url)
            #expect(failure != nil, "\(url) was accepted")
            #expect(!String(describing: failure).contains(secret))
        }
    }

    @Test func limitsAreEnforced() {
        #expect(error("https://example.com/articles/" + String(repeating: "1", count: 200)) == .tooLong)
        #expect(error("https://example.com/a/b/c/d/e") == .tooManySegments)
        #expect(error("patterns://search?q=1&a=2&b=3&c=4") == .tooManyQueryItems)
        #expect(error("https://example.com/users/" + String(repeating: "x", count: 21)) == .invalidValue("segment 2"))
    }

    @Test func noMatchAndRejectedAreDistinct() {
        #expect(error("https://example.com/unknown") == .noMatch)
        #expect(error("https://example.com/articles/abc") == .rejected)
        #expect(error("patterns://search") == .rejected)
    }

    @Test func integerParametersNeverTrap() {
        let values = ["42": 42, "0": 0]
        for (text, number) in values {
            #expect(DeepLinkParameters(path: ["id": text]).int("id") == number)
        }
        for text in ["", "-1", "+1", "1.5", "0x10", "٣", "99999999999999999999999"] {
            #expect(DeepLinkParameters(path: ["id": text]).int("id") == nil)
        }
        #expect(DeepLinkParameters().int("id") == nil)
    }

    @Test func pathValuesShadowQueryValues() {
        let parameters = DeepLinkParameters(path: ["id": "1"], query: ["id": "2", "tab": "x"])
        #expect(parameters["id"] == "1")
        #expect(parameters["tab"] == "x")
    }

    #if os(macOS)
    @Test func repeatedParameterNamesStopTheApp() async {
        await #expect(processExitsWith: .failure) {
            _ = DeepLinkParser<Int>.Pattern("a/:id/:id") { _ in [] }
        }
        await #expect(processExitsWith: .failure) {
            _ = DeepLinkParser<Int>.Pattern("a/:") { _ in [] }
        }
    }
    #endif
}
