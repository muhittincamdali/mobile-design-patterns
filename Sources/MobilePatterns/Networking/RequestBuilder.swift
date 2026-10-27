import Foundation

/// Builds a `URLRequest` step by step and checks it before handing it out: the *builder*
/// pattern.
///
/// Every step returns a new builder, so a configured base can be shared and extended. `build()`
/// percent encodes path segments and query values (a `+` in a value is sent as `%2B`, not left
/// for the server to read as a space), and refuses header names that are not HTTP tokens,
/// header values with line breaks (header injection), `.` and `..` segments, a body on `GET`, and
/// timeouts that are not positive.
///
/// ```swift
/// let api = RequestBuilder(baseURL: URL(string: "https://api.example.com/v1")!)
///     .header("Accept", "application/json")
///
/// let request = try api
///     .path("users", userID, "orders")
///     .query("status", "open")
///     .query("after", cursor)          // a nil value is left out
///     .timeout(.seconds(15))
///     .build()
/// ```
public struct RequestBuilder: Sendable {
    /// The HTTP method.
    public enum Method: String, Sendable, CaseIterable {
        case get = "GET", post = "POST", put = "PUT", patch = "PATCH", delete = "DELETE", head = "HEAD"
    }

    /// Longest header value accepted, in UTF-8 bytes.
    public static let maxHeaderValueLength = 8_192

    private let baseURL: URL
    private var method = Method.get
    private var segments: [String] = []
    private var queryItems: [(name: String, value: String)] = []
    private var headers: [(name: String, value: String)] = []
    private var body: Data?
    private var timeout = Duration.seconds(60)

    /// Creates a builder for requests below `baseURL`, which must be an `http` or `https` URL
    /// with a host and without query, fragment or credentials. ``build()`` checks it.
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }

    /// Sets the HTTP method. The default is `GET`.
    public func method(_ method: Method) -> Self {
        var copy = self
        copy.method = method
        return copy
    }

    /// Appends path segments. Each one is percent encoded as a whole, so a `/` inside a value
    /// stays part of that segment.
    public func path(_ segments: String...) -> Self {
        var copy = self
        copy.segments += segments
        return copy
    }

    /// Appends a query item. A `nil` value leaves the item out, which suits optional filters.
    public func query(_ name: String, _ value: String?) -> Self {
        guard let value else { return self }
        var copy = self
        copy.queryItems.append((name, value))
        return copy
    }

    /// Sets a header, replacing an earlier value with the same name (compared without case).
    public func header(_ name: String, _ value: String) -> Self {
        var copy = self
        copy.headers.removeAll { $0.name.caseInsensitiveCompare(name) == .orderedSame }
        copy.headers.append((name, value))
        return copy
    }

    /// Sets the body and its `Content-Type`.
    public func body(_ data: Data, contentType: String) -> Self {
        var copy = header("Content-Type", contentType)
        copy.body = data
        return copy
    }

    /// Encodes `value` as the JSON body.
    public func json<Body: Encodable>(_ value: Body, encoder: JSONEncoder = JSONEncoder()) throws -> Self {
        body(try encoder.encode(value), contentType: "application/json")
    }

    /// Sets the time limit of the request. The default is 60 seconds.
    public func timeout(_ duration: Duration) -> Self {
        var copy = self
        copy.timeout = duration
        return copy
    }

    /// Checks every part and returns the request.
    public func build() throws(RequestBuilderError) -> URLRequest {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false),
              let scheme = components.scheme?.lowercased(), ["http", "https"].contains(scheme),
              let host = components.host, !host.isEmpty,
              components.user == nil, components.password == nil,
              components.query == nil, components.fragment == nil
        else { throw .invalidBaseURL }

        for (index, segment) in segments.enumerated() where segment.isEmpty || segment == "." || segment == ".." {
            throw .invalidPathSegment(position: index + 1)
        }
        let basePath = components.percentEncodedPath.hasSuffix("/")
            ? String(components.percentEncodedPath.dropLast())
            : components.percentEncodedPath
        let encodedSegments = segments.map { $0.addingPercentEncoding(withAllowedCharacters: Self.segmentAllowed) ?? "" }
        components.percentEncodedPath = ([basePath] + encodedSegments).joined(separator: "/")

        if !queryItems.isEmpty {
            components.percentEncodedQuery = queryItems.map { item in
                Self.encodeQuery(item.name) + "=" + Self.encodeQuery(item.value)
            }.joined(separator: "&")
        }
        guard let url = components.url else { throw .invalidBaseURL }

        for header in headers {
            guard !header.name.isEmpty, header.name.unicodeScalars.allSatisfy(Self.isTokenCharacter) else {
                throw .invalidHeaderName
            }
            guard header.value.utf8.count <= Self.maxHeaderValueLength,
                  !header.value.unicodeScalars.contains(where: { $0 == "\r" || $0 == "\n" || $0 == "\0" })
            else { throw .invalidHeaderValue(name: header.name) }
        }
        if body != nil, method == .get || method == .head {
            throw .bodyNotAllowed(method.rawValue)
        }
        guard timeout > .zero else { throw .invalidTimeout }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        let parts = timeout.components
        request.timeoutInterval = Double(parts.seconds) + Double(parts.attoseconds) / 1e18
        for header in headers {
            request.setValue(header.value, forHTTPHeaderField: header.name)
        }
        return request
    }

    private static let segmentAllowed: CharacterSet = {
        var set = CharacterSet.urlPathAllowed
        set.remove(charactersIn: "/;")
        return set
    }()

    private static let queryAllowed: CharacterSet = {
        var set = CharacterSet.urlQueryAllowed
        set.remove(charactersIn: "&=+;#")
        return set
    }()

    private static func encodeQuery(_ text: String) -> String {
        text.addingPercentEncoding(withAllowedCharacters: queryAllowed) ?? ""
    }

    private static func isTokenCharacter(_ scalar: Unicode.Scalar) -> Bool {
        guard scalar.isASCII else { return false }
        switch scalar {
        case "a"..."z", "A"..."Z", "0"..."9": return true
        default: return "!#$%&'*+-.^_`|~".unicodeScalars.contains(scalar)
        }
    }
}

/// Why ``RequestBuilder/build()`` refused to build a request.
///
/// No case carries the refused text: a bad path segment is reported by its position and a bad
/// header name or value without it, so a header value with a line break or a 9 KB name cannot
/// reach a log line through the error.
public enum RequestBuilderError: Error, Equatable, Sendable {
    /// The base URL is not `http` or `https`, has no host, or carries a query, fragment or
    /// credentials.
    case invalidBaseURL
    /// A path segment is empty, `.` or `..`. Carries its position among the segments added with
    /// ``RequestBuilder/path(_:)``, counted from 1.
    case invalidPathSegment(position: Int)
    /// A header name is empty or has characters outside the HTTP token set.
    case invalidHeaderName
    /// A header value contains a line break or NUL, or is longer than
    /// ``RequestBuilder/maxHeaderValueLength``. Carries the header's name, which passed the name
    /// check, not the value.
    case invalidHeaderValue(name: String)
    /// `GET` and `HEAD` requests cannot carry a body.
    case bodyNotAllowed(String)
    /// The timeout is zero or negative.
    case invalidTimeout
}
