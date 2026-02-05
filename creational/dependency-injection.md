# Dependency Injection Pattern

> Provide dependencies externally instead of creating them internally

## Problem

- Hard-coded dependencies make testing difficult
- Tight coupling between classes
- Difficult to swap implementations

## Solution

### Constructor Injection (Preferred)

```swift
// MARK: - Protocols
protocol NetworkService {
    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

protocol UserRepository {
    func getUser(id: String) async throws -> User
    func saveUser(_ user: User) async throws
}

protocol AnalyticsService {
    func track(_ event: AnalyticsEvent)
}

// MARK: - Implementations
class URLSessionNetworkService: NetworkService {
    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: endpoint.url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

class DefaultUserRepository: UserRepository {
    private let network: NetworkService
    private let cache: UserCache
    
    init(network: NetworkService, cache: UserCache) {
        self.network = network
        self.cache = cache
    }
    
    func getUser(id: String) async throws -> User {
        if let cached = cache.get(id: id) {
            return cached
        }
        let user: User = try await network.fetch(.user(id: id))
        cache.set(user)
        return user
    }
    
    func saveUser(_ user: User) async throws {
        // Implementation
    }
}

// MARK: - ViewModel with Injected Dependencies
class UserProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let userRepository: UserRepository
    private let analytics: AnalyticsService
    
    // Constructor injection
    init(userRepository: UserRepository, analytics: AnalyticsService) {
        self.userRepository = userRepository
        self.analytics = analytics
    }
    
    func loadUser(id: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            user = try await userRepository.getUser(id: id)
            analytics.track(.profileViewed(userId: id))
        } catch {
            self.error = error
            analytics.track(.error(error))
        }
    }
}
```

### Testing with Mocks

```swift
class MockNetworkService: NetworkService {
    var mockResponse: Any?
    var mockError: Error?
    
    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        if let error = mockError { throw error }
        return mockResponse as! T
    }
}

class MockAnalytics: AnalyticsService {
    var trackedEvents: [AnalyticsEvent] = []
    
    func track(_ event: AnalyticsEvent) {
        trackedEvents.append(event)
    }
}

// Unit test
func testLoadUser() async {
    let mockNetwork = MockNetworkService()
    mockNetwork.mockResponse = User(id: "1", name: "Test")
    
    let mockAnalytics = MockAnalytics()
    let mockCache = InMemoryUserCache()
    
    let repository = DefaultUserRepository(network: mockNetwork, cache: mockCache)
    let viewModel = UserProfileViewModel(userRepository: repository, analytics: mockAnalytics)
    
    await viewModel.loadUser(id: "1")
    
    XCTAssertEqual(viewModel.user?.name, "Test")
    XCTAssertEqual(mockAnalytics.trackedEvents.count, 1)
}
```

### Container-Based DI

```swift
// MARK: - DI Container
class DIContainer {
    static let shared = DIContainer()
    
    private var factories: [String: () -> Any] = [:]
    private var singletons: [String: Any] = [:]
    
    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        factories[String(describing: type)] = factory
    }
    
    func registerSingleton<T>(_ type: T.Type, factory: @escaping () -> T) {
        factories[String(describing: type)] = { [weak self] in
            let key = String(describing: type)
            if let existing = self?.singletons[key] as? T {
                return existing
            }
            let instance = factory()
            self?.singletons[key] = instance
            return instance
        }
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        guard let factory = factories[key] else {
            fatalError("No registration for \(key)")
        }
        return factory() as! T
    }
}

// MARK: - Property Wrapper
@propertyWrapper
struct Injected<T> {
    private var service: T
    
    init() {
        self.service = DIContainer.shared.resolve(T.self)
    }
    
    var wrappedValue: T {
        get { service }
        mutating set { service = newValue }
    }
}

// MARK: - Usage with Property Wrapper
class HomeViewModel: ObservableObject {
    @Injected var userRepository: UserRepository
    @Injected var analytics: AnalyticsService
}
```

## When to Use ✅

- Need testability with mocks
- Swap implementations at runtime
- Reduce coupling between classes
- Follow SOLID principles

## When NOT to Use ❌

- Simple apps with no testing needs
- Adds unnecessary complexity
- Performance-critical code

## Related Patterns

- **Service Locator**: Alternative for dependency lookup
- **Factory Method**: Creates instances for injection
- **Strategy**: Swaps algorithms via injection
