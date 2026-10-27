import Foundation

/// Turns a URL into the navigation stack it should open, after checking it.
///
/// A deep link is input from outside the app: anyone can put one in a message or a web page. The
/// parser only accepts the schemes and hosts you list, refuses URLs with credentials, `.` or `..`
/// segments, control characters, and anything over the ``Limits``, and only then matches the
/// path against your patterns. A pattern returns the whole stack, so the back button works
/// after a link opened a detail screen.
///
/// ```swift
/// let parser = DeepLinkParser<AppRoute>(
///     schemes: ["https", "patterns"],
///     hosts: ["example.com"],
///     patterns: [
///         .init("articles") { _ in [.articles] },
///         .init("articles/:id") { parameters in
///             parameters.int("id").map { [.articles, .article(id: $0)] }
///         }
///     ]
/// )
/// let routes = try parser.routes(for: url)  // [.articles, .article(id: 42)]
/// router.replaceStack(with: routes)
/// ```
///
/// For `http` and `https` the host must be in `hosts`. For any other scheme the host is read as
/// the first path segment, so `patterns://articles/42` and `https://example.com/articles/42`
/// match the same pattern.
public struct DeepLinkParser<Route>: Sendable {
    /// Upper bounds applied before any matching.
    public struct Limits: Sendable, Equatable {
        /// Longest accepted URL, in UTF-8 bytes.
        public var maxURLLength: Int
        /// Most path segments.
        public var maxSegments: Int
        /// Longest path or query value after percent decoding, in UTF-8 bytes.
        public var maxValueLength: Int
        /// Most query items.
        public var maxQueryItems: Int

        public init(maxURLLength: Int = 2_048, maxSegments: Int = 16, maxValueLength: Int = 256, maxQueryItems: Int = 20) {
            self.maxURLLength = maxURLLength
            self.maxSegments = maxSegments
            self.maxValueLength = maxValueLength
            self.maxQueryItems = maxQueryItems
        }
    }

    /// A path template such as `"articles/:id"` and the routes it opens.
    public struct Pattern: Sendable {
        enum Segment: Equatable {
            case literal(String)
            case parameter(String)
        }

        let segments: [Segment]
        let build: @Sendable (DeepLinkParameters) -> [Route]?

        /// Creates a pattern.
        ///
        /// - Parameters:
        ///   - path: Segments separated by `/`. A segment that starts with `:` captures the value
        ///     at that position under the name that follows; other segments must match exactly.
        ///   - build: Returns the stack to open, or `nil` to refuse the link, for example when an
        ///     identifier is not a number.
        /// - Precondition: Parameter names are not empty and not repeated.
        public init(_ path: String, build: @escaping @Sendable (DeepLinkParameters) -> [Route]?) {
            let segments: [Segment] = path.split(separator: "/").map { part in
                part.hasPrefix(":") ? .parameter(String(part.dropFirst())) : .literal(String(part))
            }
            let names = segments.compactMap { segment -> String? in
                if case .parameter(let name) = segment { return name }
                return nil
            }
            precondition(!names.contains(""), "A parameter in \"\(path)\" has no name")
            precondition(Set(names).count == names.count, "A parameter name repeats in \"\(path)\"")
            self.segments = segments
            self.build = build
        }
    }

    private static var webSchemes: Set<String> { ["http", "https"] }

    private let schemes: Set<String>
    private let hosts: Set<String>
    private let limits: Limits
    private let patterns: [Pattern]

    /// Creates a parser.
    ///
    /// - Parameters:
    ///   - schemes: Accepted schemes, compared without case.
    ///   - hosts: Accepted hosts for `http` and `https` links, compared without case.
    ///   - limits: Size limits checked before matching.
    ///   - patterns: Tried in order; the first one that matches decides.
    public init(schemes: Set<String>, hosts: Set<String> = [], limits: Limits = Limits(), patterns: [Pattern]) {
        self.schemes = Set(schemes.map { $0.lowercased() })
        self.hosts = Set(hosts.map { $0.lowercased() })
        self.limits = limits
        self.patterns = patterns
    }

    /// Returns the navigation stack for `url`, or throws the first check it fails.
    public func routes(for url: URL) throws(DeepLinkError) -> [Route] {
        guard url.absoluteString.utf8.count <= limits.maxURLLength else { throw .tooLong }
        guard let scheme = url.scheme?.lowercased(), schemes.contains(scheme) else {
            throw .unsupportedScheme(url.scheme ?? "")
        }
        guard url.user(percentEncoded: true) == nil, url.password(percentEncoded: true) == nil else {
            throw .credentialsNotAllowed
        }

        var rawSegments = url.path(percentEncoded: true).split(separator: "/").map(String.init)
        let host = url.host(percentEncoded: true) ?? ""
        if Self.webSchemes.contains(scheme) {
            guard hosts.contains(host.lowercased()) else { throw .unknownHost(host) }
        } else if !host.isEmpty {
            rawSegments.insert(host, at: 0)
        }
        guard rawSegments.count <= limits.maxSegments else { throw .tooManySegments }

        var segments: [String] = []
        for (index, raw) in rawSegments.enumerated() {
            guard let decoded = raw.removingPercentEncoding, decoded != ".", decoded != ".." else {
                throw .malformedPath
            }
            try check(decoded, name: "segment \(index + 1)", allowEmpty: false)
            segments.append(decoded)
        }
        let query = try queryValues(of: url)

        for pattern in patterns {
            guard let pathValues = match(pattern, segments) else { continue }
            let parameters = DeepLinkParameters(path: pathValues, query: query)
            guard let routes = pattern.build(parameters) else { throw .rejected }
            return routes
        }
        throw .noMatch
    }

    private func match(_ pattern: Pattern, _ segments: [String]) -> [String: String]? {
        guard pattern.segments.count == segments.count else { return nil }
        var values: [String: String] = [:]
        for (expected, actual) in zip(pattern.segments, segments) {
            switch expected {
            case .literal(let literal):
                guard literal == actual else { return nil }
            case .parameter(let name):
                values[name] = actual
            }
        }
        return values
    }

    private func queryValues(of url: URL) throws(DeepLinkError) -> [String: String] {
        guard url.query(percentEncoded: true) != nil else { return [:] }
        guard let items = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems else {
            throw .malformedPath
        }
        guard items.count <= limits.maxQueryItems else { throw .tooManyQueryItems }
        var values: [String: String] = [:]
        for item in items where values[item.name] == nil {
            let value = item.value ?? ""
            try check(item.name, name: item.name, allowEmpty: false)
            try check(value, name: item.name, allowEmpty: true)
            values[item.name] = value
        }
        return values
    }

    private func check(_ value: String, name: String, allowEmpty: Bool) throws(DeepLinkError) {
        let tooLong = value.utf8.count > limits.maxValueLength
        let hasControl = value.unicodeScalars.contains { $0.properties.generalCategory == .control }
        if tooLong || hasControl || (!allowEmpty && value.isEmpty) {
            let printable = name.unicodeScalars.filter { $0.properties.generalCategory != .control }
            throw .invalidValue(String(String.UnicodeScalarView(printable).prefix(32)))
        }
    }
}

/// The values a deep link carried: named path segments and query items, percent decoded.
public struct DeepLinkParameters: Sendable, Equatable {
    /// Values of the `:name` segments of the matched pattern.
    public let path: [String: String]
    /// Query items; when a name repeats, the first value is kept.
    public let query: [String: String]

    public init(path: [String: String] = [:], query: [String: String] = [:]) {
        self.path = path
        self.query = query
    }

    /// The path value named `name`, or else the query value.
    public subscript(name: String) -> String? {
        path[name] ?? query[name]
    }

    /// The value named `name` as a non-negative decimal integer, or `nil` when it is missing,
    /// signed, not a number, or does not fit in `Int`.
    public func int(_ name: String) -> Int? {
        guard let text = self[name], !text.isEmpty, text.utf8.allSatisfy({ (0x30...0x39).contains($0) }) else {
            return nil
        }
        return Int(text)
    }
}

/// Why ``DeepLinkParser`` refused a URL.
public enum DeepLinkError: Error, Equatable, Sendable {
    /// The URL is longer than ``DeepLinkParser/Limits/maxURLLength``.
    case tooLong
    /// The scheme is not one of the accepted schemes.
    case unsupportedScheme(String)
    /// An `http` or `https` link points to a host that is not accepted.
    case unknownHost(String)
    /// The URL carries a user name or password.
    case credentialsNotAllowed
    /// A path segment is `.` or `..`, or the path or query is not valid percent encoding.
    case malformedPath
    /// The path has more segments than ``DeepLinkParser/Limits/maxSegments``.
    case tooManySegments
    /// The query has more items than ``DeepLinkParser/Limits/maxQueryItems``.
    case tooManyQueryItems
    /// A path segment or query item is empty, too long or contains control characters. Carries
    /// `"segment <n>"` for a path segment (counted from 1), or the query item's name without
    /// control characters and cut to 32 characters.
    case invalidValue(String)
    /// No pattern matched the path.
    case noMatch
    /// A pattern matched, but its build closure refused the values.
    case rejected
}
