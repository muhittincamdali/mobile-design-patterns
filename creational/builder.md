# Builder Pattern

> Construct complex objects step by step

## Problem

- Object has many optional parameters
- Object creation requires multiple steps
- Different representations of same object needed

## Solution

```swift
// MARK: - Product
struct NetworkRequest {
    let url: URL
    let method: HTTPMethod
    let headers: [String: String]
    let body: Data?
    let timeout: TimeInterval
    let cachePolicy: URLRequest.CachePolicy
    let retryCount: Int
    let authentication: Authentication?
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum Authentication {
    case bearer(String)
    case basic(username: String, password: String)
    case apiKey(String, headerName: String)
}

// MARK: - Builder
class NetworkRequestBuilder {
    private var url: URL?
    private var method: HTTPMethod = .get
    private var headers: [String: String] = [:]
    private var body: Data?
    private var timeout: TimeInterval = 30
    private var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    private var retryCount: Int = 0
    private var authentication: Authentication?
    
    @discardableResult
    func url(_ url: URL) -> Self {
        self.url = url
        return self
    }
    
    @discardableResult
    func url(_ urlString: String) -> Self {
        self.url = URL(string: urlString)
        return self
    }
    
    @discardableResult
    func method(_ method: HTTPMethod) -> Self {
        self.method = method
        return self
    }
    
    @discardableResult
    func header(_ key: String, _ value: String) -> Self {
        headers[key] = value
        return self
    }
    
    @discardableResult
    func jsonBody<T: Encodable>(_ body: T) -> Self {
        self.body = try? JSONEncoder().encode(body)
        headers["Content-Type"] = "application/json"
        return self
    }
    
    @discardableResult
    func timeout(_ seconds: TimeInterval) -> Self {
        self.timeout = seconds
        return self
    }
    
    @discardableResult
    func retry(_ count: Int) -> Self {
        self.retryCount = count
        return self
    }
    
    @discardableResult
    func bearerToken(_ token: String) -> Self {
        self.authentication = .bearer(token)
        return self
    }
    
    func build() throws -> NetworkRequest {
        guard let url = url else {
            throw BuilderError.missingURL
        }
        
        return NetworkRequest(
            url: url,
            method: method,
            headers: headers,
            body: body,
            timeout: timeout,
            cachePolicy: cachePolicy,
            retryCount: retryCount,
            authentication: authentication
        )
    }
    
    enum BuilderError: Error {
        case missingURL
    }
}

// MARK: - Director (Optional)
class RequestDirector {
    static func makeGETRequest(url: String) -> NetworkRequestBuilder {
        NetworkRequestBuilder()
            .url(url)
            .method(.get)
            .timeout(15)
    }
    
    static func makePOSTRequest<T: Encodable>(url: String, body: T) -> NetworkRequestBuilder {
        NetworkRequestBuilder()
            .url(url)
            .method(.post)
            .jsonBody(body)
            .timeout(30)
    }
}

// MARK: - Usage
let request = try NetworkRequestBuilder()
    .url("https://api.example.com/users")
    .method(.post)
    .jsonBody(CreateUserRequest(name: "John", email: "john@example.com"))
    .bearerToken("eyJhbGc...")
    .timeout(30)
    .retry(3)
    .build()
```

## Result Builder (Swift 5.4+)

```swift
@resultBuilder
struct AlertBuilder {
    static func buildBlock(_ components: AlertComponent...) -> [AlertComponent] {
        components
    }
}

protocol AlertComponent {}

struct AlertTitle: AlertComponent {
    let text: String
}

struct AlertMessage: AlertComponent {
    let text: String
}

struct AlertAction: AlertComponent {
    let title: String
    let style: UIAlertAction.Style
    let handler: () -> Void
}

class Alert {
    private var title: String?
    private var message: String?
    private var actions: [AlertAction] = []
    
    init(@AlertBuilder _ content: () -> [AlertComponent]) {
        for component in content() {
            switch component {
            case let title as AlertTitle:
                self.title = title.text
            case let message as AlertMessage:
                self.message = message.text
            case let action as AlertAction:
                self.actions.append(action)
            default:
                break
            }
        }
    }
}

// Usage
let alert = Alert {
    AlertTitle(text: "Delete Item?")
    AlertMessage(text: "This action cannot be undone.")
    AlertAction(title: "Cancel", style: .cancel) {}
    AlertAction(title: "Delete", style: .destructive) {
        deleteItem()
    }
}
```

## When to Use ✅

- Complex object with many parameters
- Step-by-step construction needed
- Different representations required
- Immutable objects with many properties

## When NOT to Use ❌

- Simple objects with few properties
- Object can be created in one step
- No optional parameters

## Related Patterns

- **Abstract Factory**: Build entire families of products
- **Composite**: Builders often compose complex objects
- **Prototype**: Alternative when objects are similar
