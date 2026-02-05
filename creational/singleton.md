# Singleton Pattern

> Ensure a class has only one instance with global access point

## Problem

You need a single shared instance across the entire app:
- Configuration settings
- Analytics service
- Database connection
- Network manager

## Solution

```swift
final class AppConfig {
    // MARK: - Singleton Instance
    static let shared = AppConfig()
    
    // MARK: - Properties
    private(set) var apiBaseURL: URL
    private(set) var environment: Environment
    private(set) var isDebugMode: Bool
    
    // MARK: - Private Init (prevents external instantiation)
    private init() {
        #if DEBUG
        self.environment = .development
        self.isDebugMode = true
        self.apiBaseURL = URL(string: "https://api-dev.example.com")!
        #else
        self.environment = .production
        self.isDebugMode = false
        self.apiBaseURL = URL(string: "https://api.example.com")!
        #endif
    }
    
    // MARK: - Configuration
    func configure(for environment: Environment) {
        self.environment = environment
        switch environment {
        case .development:
            apiBaseURL = URL(string: "https://api-dev.example.com")!
        case .staging:
            apiBaseURL = URL(string: "https://api-staging.example.com")!
        case .production:
            apiBaseURL = URL(string: "https://api.example.com")!
        }
    }
}

enum Environment {
    case development, staging, production
}

// MARK: - Usage
AppConfig.shared.configure(for: .staging)
print(AppConfig.shared.apiBaseURL) // https://api-staging.example.com
```

## Thread-Safe Singleton with Custom Initialization

```swift
final class DatabaseManager {
    static let shared: DatabaseManager = {
        let instance = DatabaseManager()
        instance.setup()
        return instance
    }()
    
    private var database: Database?
    private let queue = DispatchQueue(label: "com.app.database", attributes: .concurrent)
    
    private init() {}
    
    private func setup() {
        database = Database(path: "app.db")
        database?.migrate()
    }
    
    func read<T>(_ block: (Database) -> T) -> T {
        queue.sync {
            block(database!)
        }
    }
    
    func write(_ block: @escaping (Database) -> Void) {
        queue.async(flags: .barrier) {
            block(self.database!)
        }
    }
}
```

## When to Use ✅

- Exactly one instance needed (configuration, analytics)
- Global access required
- Lazy initialization is acceptable
- Instance is stateless or thread-safe

## When NOT to Use ❌

- Need multiple instances with different configs
- Unit testing with different mock states
- Dependency injection is feasible
- Instance holds non-sharable resources

## Common Mistakes

```swift
// ❌ WRONG: Mutable global state
class BadSingleton {
    static let shared = BadSingleton()
    var user: User? // Mutable state - race conditions!
}

// ✅ CORRECT: Thread-safe state
final class GoodSingleton {
    static let shared = GoodSingleton()
    
    private let lock = NSLock()
    private var _user: User?
    
    var user: User? {
        get { lock.withLock { _user } }
        set { lock.withLock { _user = newValue } }
    }
}

// ❌ WRONG: Hard to test
class ViewController {
    func loadData() {
        NetworkManager.shared.fetch() // Hard-coded dependency
    }
}

// ✅ CORRECT: Injectable
class ViewController {
    private let networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging = NetworkManager.shared) {
        self.networkManager = networkManager
    }
}
```

## Real-World Examples

- `UserDefaults.standard`
- `FileManager.default`
- `URLSession.shared`
- `NotificationCenter.default`

## Related Patterns

- **Dependency Injection**: Alternative approach for managing shared instances
- **Object Pool**: For managing multiple reusable instances
- **Monostate**: Shared state without single instance restriction
