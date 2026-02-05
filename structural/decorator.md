# Decorator Pattern

> Attach additional responsibilities to an object dynamically

## Problem

- Need to add behavior to objects at runtime
- Inheritance would create explosion of subclasses
- Want to add/remove responsibilities dynamically

## Solution

```swift
// MARK: - Component Protocol
protocol DataSource {
    func read() async throws -> Data
    func write(_ data: Data) async throws
}

// MARK: - Concrete Component
class FileDataSource: DataSource {
    private let path: String
    
    init(path: String) {
        self.path = path
    }
    
    func read() async throws -> Data {
        try Data(contentsOf: URL(fileURLWithPath: path))
    }
    
    func write(_ data: Data) async throws {
        try data.write(to: URL(fileURLWithPath: path))
    }
}

// MARK: - Base Decorator
class DataSourceDecorator: DataSource {
    let wrappee: DataSource
    
    init(_ wrappee: DataSource) {
        self.wrappee = wrappee
    }
    
    func read() async throws -> Data {
        try await wrappee.read()
    }
    
    func write(_ data: Data) async throws {
        try await wrappee.write(data)
    }
}

// MARK: - Encryption Decorator
class EncryptionDecorator: DataSourceDecorator {
    private let key: SymmetricKey
    
    init(_ wrappee: DataSource, key: SymmetricKey) {
        self.key = key
        super.init(wrappee)
    }
    
    override func read() async throws -> Data {
        let encryptedData = try await super.read()
        return try decrypt(encryptedData)
    }
    
    override func write(_ data: Data) async throws {
        let encryptedData = try encrypt(data)
        try await super.write(encryptedData)
    }
    
    private func encrypt(_ data: Data) throws -> Data {
        let sealedBox = try AES.GCM.seal(data, using: key)
        return sealedBox.combined!
    }
    
    private func decrypt(_ data: Data) throws -> Data {
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        return try AES.GCM.open(sealedBox, using: key)
    }
}

// MARK: - Compression Decorator
class CompressionDecorator: DataSourceDecorator {
    override func read() async throws -> Data {
        let compressedData = try await super.read()
        return try (compressedData as NSData).decompressed(using: .lzfse) as Data
    }
    
    override func write(_ data: Data) async throws {
        let compressedData = try (data as NSData).compressed(using: .lzfse) as Data
        try await super.write(compressedData)
    }
}

// MARK: - Logging Decorator
class LoggingDecorator: DataSourceDecorator {
    private let logger: Logger
    
    init(_ wrappee: DataSource, logger: Logger = Logger()) {
        self.logger = logger
        super.init(wrappee)
    }
    
    override func read() async throws -> Data {
        logger.info("Reading data...")
        let start = Date()
        let data = try await super.read()
        let duration = Date().timeIntervalSince(start)
        logger.info("Read \(data.count) bytes in \(duration)s")
        return data
    }
    
    override func write(_ data: Data) async throws {
        logger.info("Writing \(data.count) bytes...")
        let start = Date()
        try await super.write(data)
        let duration = Date().timeIntervalSince(start)
        logger.info("Write completed in \(duration)s")
    }
}

// MARK: - Caching Decorator
class CachingDecorator: DataSourceDecorator {
    private var cache: Data?
    private var cacheDate: Date?
    private let ttl: TimeInterval
    
    init(_ wrappee: DataSource, ttl: TimeInterval = 300) {
        self.ttl = ttl
        super.init(wrappee)
    }
    
    override func read() async throws -> Data {
        if let cached = cache,
           let date = cacheDate,
           Date().timeIntervalSince(date) < ttl {
            return cached
        }
        
        let data = try await super.read()
        cache = data
        cacheDate = Date()
        return data
    }
    
    override func write(_ data: Data) async throws {
        try await super.write(data)
        cache = data
        cacheDate = Date()
    }
}

// MARK: - Usage - Stack Decorators
let key = SymmetricKey(size: .bits256)

let dataSource: DataSource = LoggingDecorator(
    CachingDecorator(
        CompressionDecorator(
            EncryptionDecorator(
                FileDataSource(path: "/data/user.dat"),
                key: key
            )
        )
    )
)

// Operations go through all layers:
// Logging → Caching → Compression → Encryption → File
try await dataSource.write(userData)
let data = try await dataSource.read()
```

## Network Request Decorator

```swift
protocol HTTPClient {
    func execute(_ request: URLRequest) async throws -> (Data, URLResponse)
}

class URLSessionHTTPClient: HTTPClient {
    func execute(_ request: URLRequest) async throws -> (Data, URLResponse) {
        try await URLSession.shared.data(for: request)
    }
}

class AuthenticatedHTTPClient: HTTPClient {
    private let client: HTTPClient
    private let tokenProvider: TokenProvider
    
    init(_ client: HTTPClient, tokenProvider: TokenProvider) {
        self.client = client
        self.tokenProvider = tokenProvider
    }
    
    func execute(_ request: URLRequest) async throws -> (Data, URLResponse) {
        var authenticatedRequest = request
        let token = try await tokenProvider.getToken()
        authenticatedRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return try await client.execute(authenticatedRequest)
    }
}

class RetryingHTTPClient: HTTPClient {
    private let client: HTTPClient
    private let maxRetries: Int
    
    init(_ client: HTTPClient, maxRetries: Int = 3) {
        self.client = client
        self.maxRetries = maxRetries
    }
    
    func execute(_ request: URLRequest) async throws -> (Data, URLResponse) {
        var lastError: Error?
        
        for attempt in 0..<maxRetries {
            do {
                return try await client.execute(request)
            } catch {
                lastError = error
                let delay = pow(2.0, Double(attempt))
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
        }
        
        throw lastError!
    }
}
```

## When to Use ✅

- Add responsibilities dynamically
- Avoid subclass explosion
- Can't modify existing classes
- Need to combine behaviors

## When NOT to Use ❌

- Single responsibility needed
- Order of decorators matters critically
- Performance overhead is unacceptable

## Related Patterns

- **Adapter**: Changes interface, not behavior
- **Composite**: Similar structure, different purpose
- **Proxy**: Controls access, doesn't add behavior
