// DependencyInjection.swift
// Various DI patterns and container implementations

import Foundation

// MARK: - Property Wrapper Injection

@propertyWrapper
struct Injected<T> {
    private var value: T?
    private let keyPath: KeyPath<DIContainer, T>
    
    init(_ keyPath: KeyPath<DIContainer, T>) {
        self.keyPath = keyPath
    }
    
    var wrappedValue: T {
        mutating get {
            if let value = value {
                return value
            }
            let resolved = DIContainer.shared[keyPath: keyPath]
            value = resolved
            return resolved
        }
    }
}

@propertyWrapper
struct LazyInjected<T> {
    private var value: T?
    private let resolver: () -> T
    
    init(_ resolver: @escaping @autoclosure () -> T) {
        self.resolver = resolver
    }
    
    var wrappedValue: T {
        mutating get {
            if let value = value {
                return value
            }
            let resolved = resolver()
            value = resolved
            return resolved
        }
    }
}

// MARK: - DI Container

final class DIContainer {
    static let shared = DIContainer()
    
    private var factories: [ObjectIdentifier: Any] = [:]
    private var singletons: [ObjectIdentifier: Any] = [:]
    private let lock = NSRecursiveLock()
    
    private init() {
        registerDefaults()
    }
    
    // MARK: - Registration
    
    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        factories[key] = factory
    }
    
    func registerSingleton<T>(_ type: T.Type, factory: @escaping () -> T) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        factories[key] = { [weak self] () -> T in
            guard let self = self else { fatalError("Container deallocated") }
            
            if let existing = self.singletons[key] as? T {
                return existing
            }
            
            let instance = factory()
            self.singletons[key] = instance
            return instance
        }
    }
    
    func registerSingleton<T>(_ type: T.Type, instance: T) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        singletons[key] = instance
        factories[key] = { [weak self] () -> T in
            self?.singletons[key] as! T
        }
    }
    
    // MARK: - Resolution
    
    func resolve<T>(_ type: T.Type) -> T {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        
        guard let factory = factories[key] as? () -> T else {
            fatalError("No registration found for \(type)")
        }
        
        return factory()
    }
    
    func resolve<T>() -> T {
        resolve(T.self)
    }
    
    // MARK: - Scoped Container
    
    func createScope() -> ScopedContainer {
        ScopedContainer(parent: self)
    }
    
    // MARK: - Default Registrations
    
    private func registerDefaults() {
        // Services
        registerSingleton(NetworkServiceProtocol.self) {
            NetworkServiceImpl()
        }
        
        registerSingleton(StorageServiceProtocol.self) {
            StorageServiceImpl()
        }
        
        registerSingleton(AnalyticsServiceProtocol.self) {
            AnalyticsServiceImpl()
        }
        
        registerSingleton(AuthServiceProtocol.self) { [weak self] in
            guard let self = self else { fatalError() }
            return AuthServiceImpl(
                network: self.resolve(),
                storage: self.resolve()
            )
        }
        
        // Repositories
        register(UserRepositoryProtocol.self) { [weak self] in
            guard let self = self else { fatalError() }
            return UserRepositoryImpl()
        }
    }
    
    // MARK: - Convenience Accessors
    
    var networkService: NetworkServiceProtocol { resolve() }
    var storageService: StorageServiceProtocol { resolve() }
    var analyticsService: AnalyticsServiceProtocol { resolve() }
    var authService: AuthServiceProtocol { resolve() }
    var userRepository: UserRepositoryProtocol { resolve() }
}

// MARK: - Scoped Container

final class ScopedContainer {
    private let parent: DIContainer
    private var scopedSingletons: [ObjectIdentifier: Any] = [:]
    private var scopedFactories: [ObjectIdentifier: Any] = [:]
    private let lock = NSRecursiveLock()
    
    init(parent: DIContainer) {
        self.parent = parent
    }
    
    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        scopedFactories[key] = factory
    }
    
    func registerSingleton<T>(_ type: T.Type, factory: @escaping () -> T) {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        scopedFactories[key] = { [weak self] () -> T in
            guard let self = self else { fatalError() }
            
            if let existing = self.scopedSingletons[key] as? T {
                return existing
            }
            
            let instance = factory()
            self.scopedSingletons[key] = instance
            return instance
        }
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        lock.lock()
        defer { lock.unlock() }
        
        let key = ObjectIdentifier(type)
        
        // Check scoped factories first
        if let factory = scopedFactories[key] as? () -> T {
            return factory()
        }
        
        // Fall back to parent
        return parent.resolve(type)
    }
}

// MARK: - Service Protocols

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: String) async throws -> T
    func upload(data: Data, to endpoint: String) async throws -> String
}

protocol StorageServiceProtocol {
    func save<T: Codable>(_ value: T, forKey key: String) throws
    func load<T: Codable>(forKey key: String) -> T?
    func remove(forKey key: String)
    func clear()
}

protocol AnalyticsServiceProtocol {
    func track(event: String, properties: [String: Any]?)
    func setUser(id: String, properties: [String: Any]?)
    func reset()
}

protocol AuthServiceProtocol {
    var isAuthenticated: Bool { get }
    var currentUserId: String? { get }
    func login(email: String, password: String) async throws -> AuthToken
    func logout() async throws
    func refreshToken() async throws -> AuthToken
}

struct AuthToken: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresAt: Date
}

// MARK: - Service Implementations

final class NetworkServiceImpl: NetworkServiceProtocol {
    private let session: URLSession
    private let baseURL: URL
    
    init(baseURL: URL = URL(string: "https://api.example.com")!, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    func request<T: Decodable>(_ endpoint: String) async throws -> T {
        let url = baseURL.appendingPathComponent(endpoint)
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func upload(data: Data, to endpoint: String) async throws -> String {
        let url = baseURL.appendingPathComponent(endpoint)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        
        let (responseData, _) = try await session.upload(for: request, from: data)
        
        guard let response = try? JSONDecoder().decode([String: String].self, from: responseData),
              let uploadId = response["id"] else {
            throw NSError(domain: "Upload", code: -1)
        }
        
        return uploadId
    }
}

final class StorageServiceImpl: StorageServiceProtocol {
    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    func save<T: Codable>(_ value: T, forKey key: String) throws {
        let data = try encoder.encode(value)
        defaults.set(data, forKey: key)
    }
    
    func load<T: Codable>(forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? decoder.decode(T.self, from: data)
    }
    
    func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
    
    func clear() {
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
    }
}

final class AnalyticsServiceImpl: AnalyticsServiceProtocol {
    private var userId: String?
    private var userProperties: [String: Any] = [:]
    
    func track(event: String, properties: [String: Any]?) {
        var eventProperties = properties ?? [:]
        eventProperties["timestamp"] = Date()
        eventProperties["userId"] = userId
        
        // Send to analytics backend
        print("Analytics: \(event) - \(eventProperties)")
    }
    
    func setUser(id: String, properties: [String: Any]?) {
        userId = id
        userProperties = properties ?? [:]
    }
    
    func reset() {
        userId = nil
        userProperties = [:]
    }
}

final class AuthServiceImpl: AuthServiceProtocol {
    private let network: NetworkServiceProtocol
    private let storage: StorageServiceProtocol
    
    private var token: AuthToken?
    
    var isAuthenticated: Bool {
        guard let token = token else { return false }
        return token.expiresAt > Date()
    }
    
    var currentUserId: String? {
        // Extract from token
        nil
    }
    
    init(network: NetworkServiceProtocol, storage: StorageServiceProtocol) {
        self.network = network
        self.storage = storage
        self.token = storage.load(forKey: "auth_token")
    }
    
    func login(email: String, password: String) async throws -> AuthToken {
        // Simulate login
        try await Task.sleep(nanoseconds: 500_000_000)
        
        let token = AuthToken(
            accessToken: "access_\(UUID().uuidString)",
            refreshToken: "refresh_\(UUID().uuidString)",
            expiresAt: Date().addingTimeInterval(3600)
        )
        
        self.token = token
        try? storage.save(token, forKey: "auth_token")
        
        return token
    }
    
    func logout() async throws {
        token = nil
        storage.remove(forKey: "auth_token")
    }
    
    func refreshToken() async throws -> AuthToken {
        guard let currentToken = token else {
            throw NSError(domain: "Auth", code: 401)
        }
        
        // Simulate refresh
        try await Task.sleep(nanoseconds: 300_000_000)
        
        let newToken = AuthToken(
            accessToken: "access_\(UUID().uuidString)",
            refreshToken: currentToken.refreshToken,
            expiresAt: Date().addingTimeInterval(3600)
        )
        
        self.token = newToken
        try? storage.save(newToken, forKey: "auth_token")
        
        return newToken
    }
}

// MARK: - Factory Pattern

protocol Factory {
    associatedtype Product
    func create() -> Product
}

protocol ParameterizedFactory {
    associatedtype Product
    associatedtype Parameter
    func create(with parameter: Parameter) -> Product
}

// MARK: - View Model Factory

final class ViewModelFactory {
    private let container: DIContainer
    
    init(container: DIContainer = .shared) {
        self.container = container
    }
    
    func createUserListViewModel() -> UserListViewModel {
        let repository = container.resolve(UserRepositoryProtocol.self)
        
        return UserListViewModel(
            fetchUsersUseCase: FetchUsersUseCaseImpl(repository: repository),
            searchUsersUseCase: SearchUsersUseCaseImpl(repository: repository),
            deleteUserUseCase: DeleteUserUseCaseImpl(repository: repository)
        )
    }
    
    func createUserDetailViewModel(userId: String) -> UserDetailViewModel {
        let repository = container.resolve(UserRepositoryProtocol.self)
        return UserDetailViewModel(userId: userId, repository: repository)
    }
}

// MARK: - Abstract Factory

protocol ViewControllerFactoryProtocol {
    func createUserListViewController() -> UIViewController
    func createUserDetailViewController(userId: String) -> UIViewController
    func createSettingsViewController() -> UIViewController
}

final class ProductionViewControllerFactory: ViewControllerFactoryProtocol {
    private let viewModelFactory: ViewModelFactory
    
    init(viewModelFactory: ViewModelFactory) {
        self.viewModelFactory = viewModelFactory
    }
    
    func createUserListViewController() -> UIViewController {
        let viewModel = viewModelFactory.createUserListViewModel()
        return UserListViewController(viewModel: viewModel)
    }
    
    func createUserDetailViewController(userId: String) -> UIViewController {
        let viewModel = viewModelFactory.createUserDetailViewModel(userId: userId)
        return UserDetailViewController(viewModel: viewModel)
    }
    
    func createSettingsViewController() -> UIViewController {
        // Return actual settings VC
        UIViewController()
    }
}

final class MockViewControllerFactory: ViewControllerFactoryProtocol {
    func createUserListViewController() -> UIViewController {
        UIViewController()
    }
    
    func createUserDetailViewController(userId: String) -> UIViewController {
        UIViewController()
    }
    
    func createSettingsViewController() -> UIViewController {
        UIViewController()
    }
}

// MARK: - Service Locator (Anti-pattern but sometimes useful)

final class ServiceLocator {
    static let shared = ServiceLocator()
    
    private var services: [String: Any] = [:]
    
    private init() {}
    
    func register<T>(_ service: T) {
        let key = String(describing: T.self)
        services[key] = service
    }
    
    func resolve<T>() -> T? {
        let key = String(describing: T.self)
        return services[key] as? T
    }
    
    func reset() {
        services.removeAll()
    }
}

// MARK: - Environment-based Configuration

enum Environment {
    case development
    case staging
    case production
    
    static var current: Environment {
        #if DEBUG
        return .development
        #else
        if let config = Bundle.main.infoDictionary?["Configuration"] as? String {
            switch config.lowercased() {
            case "staging": return .staging
            default: return .production
            }
        }
        return .production
        #endif
    }
}

struct AppConfiguration {
    let apiBaseURL: URL
    let analyticsEnabled: Bool
    let logLevel: LogLevel
    let featureFlags: FeatureFlags
    
    static func forEnvironment(_ environment: Environment) -> AppConfiguration {
        switch environment {
        case .development:
            return AppConfiguration(
                apiBaseURL: URL(string: "https://dev-api.example.com")!,
                analyticsEnabled: false,
                logLevel: .debug,
                featureFlags: FeatureFlags(newFeature: true, betaFeature: true)
            )
        case .staging:
            return AppConfiguration(
                apiBaseURL: URL(string: "https://staging-api.example.com")!,
                analyticsEnabled: true,
                logLevel: .info,
                featureFlags: FeatureFlags(newFeature: true, betaFeature: true)
            )
        case .production:
            return AppConfiguration(
                apiBaseURL: URL(string: "https://api.example.com")!,
                analyticsEnabled: true,
                logLevel: .error,
                featureFlags: FeatureFlags(newFeature: false, betaFeature: false)
            )
        }
    }
}

enum LogLevel {
    case debug, info, warning, error
}

struct FeatureFlags {
    let newFeature: Bool
    let betaFeature: Bool
}

// MARK: - Module-based DI

protocol Module {
    func register(in container: DIContainer)
}

final class NetworkModule: Module {
    func register(in container: DIContainer) {
        container.registerSingleton(NetworkServiceProtocol.self) {
            NetworkServiceImpl()
        }
    }
}

final class StorageModule: Module {
    func register(in container: DIContainer) {
        container.registerSingleton(StorageServiceProtocol.self) {
            StorageServiceImpl()
        }
    }
}

final class AuthModule: Module {
    func register(in container: DIContainer) {
        container.registerSingleton(AuthServiceProtocol.self) {
            AuthServiceImpl(
                network: container.resolve(),
                storage: container.resolve()
            )
        }
    }
}

final class ModuleLoader {
    private let container: DIContainer
    
    init(container: DIContainer = .shared) {
        self.container = container
    }
    
    func load(_ modules: [Module]) {
        modules.forEach { $0.register(in: container) }
    }
}

// Usage
/*
let loader = ModuleLoader()
loader.load([
    NetworkModule(),
    StorageModule(),
    AuthModule()
])
*/
