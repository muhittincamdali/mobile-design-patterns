// NetworkingPatterns.swift
// Comprehensive networking implementations using design patterns

import Foundation
import Combine

// MARK: - Result Builder for Request Building

@resultBuilder
struct RequestBuilder {
    static func buildBlock(_ components: RequestComponent...) -> [RequestComponent] {
        components
    }
}

protocol RequestComponent {
    func apply(to request: inout URLRequest)
}

struct Header: RequestComponent {
    let name: String
    let value: String
    
    func apply(to request: inout URLRequest) {
        request.setValue(value, forHTTPHeaderField: name)
    }
}

struct QueryItem: RequestComponent {
    let name: String
    let value: String?
    
    func apply(to request: inout URLRequest) {
        guard let url = request.url,
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return
        }
        var items = components.queryItems ?? []
        items.append(URLQueryItem(name: name, value: value))
        components.queryItems = items
        request.url = components.url
    }
}

struct Body: RequestComponent {
    let data: Data
    
    func apply(to request: inout URLRequest) {
        request.httpBody = data
    }
}

// MARK: - API Endpoint Protocol

protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryItems: [URLQueryItem] { get }
    var body: Data? { get }
    var timeoutInterval: TimeInterval { get }
    var cachePolicy: URLRequest.CachePolicy { get }
}

extension APIEndpoint {
    var headers: [String: String] { [:] }
    var queryItems: [URLQueryItem] { [] }
    var body: Data? { nil }
    var timeoutInterval: TimeInterval { 30 }
    var cachePolicy: URLRequest.CachePolicy { .useProtocolCachePolicy }
    
    func asURLRequest() throws -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeoutInterval
        request.cachePolicy = cachePolicy
        request.httpBody = body
        
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        return request
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

// MARK: - Concrete Endpoints

enum UserEndpoint: APIEndpoint {
    case getUser(id: String)
    case updateUser(id: String, data: UserUpdateRequest)
    case deleteUser(id: String)
    case listUsers(page: Int, limit: Int)
    case searchUsers(query: String)
    
    var baseURL: URL {
        URL(string: "https://api.example.com/v1")!
    }
    
    var path: String {
        switch self {
        case .getUser(let id), .updateUser(let id, _), .deleteUser(let id):
            return "users/\(id)"
        case .listUsers, .searchUsers:
            return "users"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUser, .listUsers, .searchUsers:
            return .get
        case .updateUser:
            return .put
        case .deleteUser:
            return .delete
        }
    }
    
    var headers: [String: String] {
        ["Content-Type": "application/json", "Accept": "application/json"]
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .listUsers(let page, let limit):
            return [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
        case .searchUsers(let query):
            return [URLQueryItem(name: "q", value: query)]
        default:
            return []
        }
    }
    
    var body: Data? {
        switch self {
        case .updateUser(_, let data):
            return try? JSONEncoder().encode(data)
        default:
            return nil
        }
    }
}

struct UserUpdateRequest: Encodable {
    let name: String?
    let email: String?
    let avatarURL: String?
}

// MARK: - Network Error

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingFailed(Error)
    case encodingFailed(Error)
    case httpError(statusCode: Int, data: Data?)
    case networkUnavailable
    case timeout
    case cancelled
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingFailed(let error):
            return "Decoding failed: \(error.localizedDescription)"
        case .encodingFailed(let error):
            return "Encoding failed: \(error.localizedDescription)"
        case .httpError(let statusCode, _):
            return "HTTP error: \(statusCode)"
        case .networkUnavailable:
            return "Network unavailable"
        case .timeout:
            return "Request timed out"
        case .cancelled:
            return "Request cancelled"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}

// MARK: - Network Client Protocol

protocol NetworkClient {
    func send<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
    func send(_ endpoint: APIEndpoint) async throws -> Data
    func upload(_ endpoint: APIEndpoint, fileURL: URL, progressHandler: ((Double) -> Void)?) async throws -> Data
    func download(_ endpoint: APIEndpoint, progressHandler: ((Double) -> Void)?) async throws -> URL
}

// MARK: - URL Session Network Client

final class URLSessionNetworkClient: NetworkClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let requestInterceptors: [RequestInterceptor]
    private let responseInterceptors: [ResponseInterceptor]
    
    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        requestInterceptors: [RequestInterceptor] = [],
        responseInterceptors: [ResponseInterceptor] = []
    ) {
        self.session = session
        self.decoder = decoder
        self.requestInterceptors = requestInterceptors
        self.responseInterceptors = responseInterceptors
    }
    
    func send<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        let data = try await send(endpoint)
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
    
    func send(_ endpoint: APIEndpoint) async throws -> Data {
        var request = try endpoint.asURLRequest()
        
        // Apply request interceptors
        for interceptor in requestInterceptors {
            request = try await interceptor.intercept(request)
        }
        
        let (data, response) = try await session.data(for: request)
        
        // Apply response interceptors
        var processedData = data
        for interceptor in responseInterceptors {
            processedData = try await interceptor.intercept(processedData, response: response)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown(NSError(domain: "Invalid response", code: -1))
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode, data: data)
        }
        
        return processedData
    }
    
    func upload(_ endpoint: APIEndpoint, fileURL: URL, progressHandler: ((Double) -> Void)?) async throws -> Data {
        let request = try endpoint.asURLRequest()
        
        return try await withCheckedThrowingContinuation { continuation in
            let task = session.uploadTask(with: request, fromFile: fileURL) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: NetworkError.unknown(error))
                    return
                }
                
                guard let data = data else {
                    continuation.resume(throwing: NetworkError.noData)
                    return
                }
                
                continuation.resume(returning: data)
            }
            
            // Progress observation would require URLSessionTaskDelegate
            task.resume()
        }
    }
    
    func download(_ endpoint: APIEndpoint, progressHandler: ((Double) -> Void)?) async throws -> URL {
        let request = try endpoint.asURLRequest()
        
        let (url, response) = try await session.download(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1, data: nil)
        }
        
        return url
    }
}

// MARK: - Interceptors (Chain of Responsibility Pattern)

protocol RequestInterceptor {
    func intercept(_ request: URLRequest) async throws -> URLRequest
}

protocol ResponseInterceptor {
    func intercept(_ data: Data, response: URLResponse) async throws -> Data
}

final class AuthenticationInterceptor: RequestInterceptor {
    private let tokenProvider: () -> String?
    
    init(tokenProvider: @escaping () -> String?) {
        self.tokenProvider = tokenProvider
    }
    
    func intercept(_ request: URLRequest) async throws -> URLRequest {
        var modifiedRequest = request
        
        if let token = tokenProvider() {
            modifiedRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return modifiedRequest
    }
}

final class LoggingInterceptor: RequestInterceptor, ResponseInterceptor {
    func intercept(_ request: URLRequest) async throws -> URLRequest {
        print("➡️ \(request.httpMethod ?? "GET") \(request.url?.absoluteString ?? "")")
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("   Body: \(bodyString.prefix(200))")
        }
        return request
    }
    
    func intercept(_ data: Data, response: URLResponse) async throws -> Data {
        if let httpResponse = response as? HTTPURLResponse {
            print("⬅️ \(httpResponse.statusCode) \(response.url?.absoluteString ?? "")")
        }
        return data
    }
}

final class RetryInterceptor: RequestInterceptor {
    private let maxRetries: Int
    private let retryDelay: TimeInterval
    
    init(maxRetries: Int = 3, retryDelay: TimeInterval = 1.0) {
        self.maxRetries = maxRetries
        self.retryDelay = retryDelay
    }
    
    func intercept(_ request: URLRequest) async throws -> URLRequest {
        // Retry logic would be implemented in the client
        // This interceptor just marks the request as retryable
        var modifiedRequest = request
        modifiedRequest.setValue("\(maxRetries)", forHTTPHeaderField: "X-Max-Retries")
        return modifiedRequest
    }
}

// MARK: - Repository Pattern

protocol UserRepository {
    func getUser(id: String) async throws -> User
    func updateUser(id: String, request: UserUpdateRequest) async throws -> User
    func deleteUser(id: String) async throws
    func listUsers(page: Int, limit: Int) async throws -> PaginatedResponse<User>
    func searchUsers(query: String) async throws -> [User]
}

struct User: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let email: String
    let avatarURL: String?
    let createdAt: Date
    let updatedAt: Date
}

struct PaginatedResponse<T: Codable>: Codable {
    let items: [T]
    let page: Int
    let totalPages: Int
    let totalItems: Int
}

final class NetworkUserRepository: UserRepository {
    private let client: NetworkClient
    
    init(client: NetworkClient) {
        self.client = client
    }
    
    func getUser(id: String) async throws -> User {
        try await client.send(UserEndpoint.getUser(id: id))
    }
    
    func updateUser(id: String, request: UserUpdateRequest) async throws -> User {
        try await client.send(UserEndpoint.updateUser(id: id, data: request))
    }
    
    func deleteUser(id: String) async throws {
        _ = try await client.send(UserEndpoint.deleteUser(id: id))
    }
    
    func listUsers(page: Int, limit: Int) async throws -> PaginatedResponse<User> {
        try await client.send(UserEndpoint.listUsers(page: page, limit: limit))
    }
    
    func searchUsers(query: String) async throws -> [User] {
        try await client.send(UserEndpoint.searchUsers(query: query))
    }
}

// MARK: - Caching Decorator Pattern

final class CachingUserRepository: UserRepository {
    private let wrapped: UserRepository
    private let cache: NSCache<NSString, CacheEntry<User>>
    private let listCache: NSCache<NSString, CacheEntry<PaginatedResponse<User>>>
    private let cacheDuration: TimeInterval
    
    init(wrapped: UserRepository, cacheDuration: TimeInterval = 300) {
        self.wrapped = wrapped
        self.cacheDuration = cacheDuration
        self.cache = NSCache()
        self.listCache = NSCache()
        cache.countLimit = 100
        listCache.countLimit = 20
    }
    
    func getUser(id: String) async throws -> User {
        let key = NSString(string: "user_\(id)")
        
        if let entry = cache.object(forKey: key), !entry.isExpired {
            return entry.value
        }
        
        let user = try await wrapped.getUser(id: id)
        cache.setObject(CacheEntry(value: user, duration: cacheDuration), forKey: key)
        return user
    }
    
    func updateUser(id: String, request: UserUpdateRequest) async throws -> User {
        let user = try await wrapped.updateUser(id: id, request: request)
        
        // Invalidate cache
        let key = NSString(string: "user_\(id)")
        cache.removeObject(forKey: key)
        
        return user
    }
    
    func deleteUser(id: String) async throws {
        try await wrapped.deleteUser(id: id)
        
        // Invalidate cache
        let key = NSString(string: "user_\(id)")
        cache.removeObject(forKey: key)
    }
    
    func listUsers(page: Int, limit: Int) async throws -> PaginatedResponse<User> {
        let key = NSString(string: "users_\(page)_\(limit)")
        
        if let entry = listCache.object(forKey: key), !entry.isExpired {
            return entry.value
        }
        
        let response = try await wrapped.listUsers(page: page, limit: limit)
        listCache.setObject(CacheEntry(value: response, duration: cacheDuration), forKey: key)
        
        // Cache individual users
        for user in response.items {
            let userKey = NSString(string: "user_\(user.id)")
            cache.setObject(CacheEntry(value: user, duration: cacheDuration), forKey: userKey)
        }
        
        return response
    }
    
    func searchUsers(query: String) async throws -> [User] {
        // Don't cache search results
        try await wrapped.searchUsers(query: query)
    }
    
    func invalidateAll() {
        cache.removeAllObjects()
        listCache.removeAllObjects()
    }
}

final class CacheEntry<T> {
    let value: T
    let expirationDate: Date
    
    var isExpired: Bool {
        Date() > expirationDate
    }
    
    init(value: T, duration: TimeInterval) {
        self.value = value
        self.expirationDate = Date().addingTimeInterval(duration)
    }
}

// MARK: - Offline Support Decorator

final class OfflineUserRepository: UserRepository {
    private let online: UserRepository
    private let storage: LocalStorage
    
    init(online: UserRepository, storage: LocalStorage) {
        self.online = online
        self.storage = storage
    }
    
    func getUser(id: String) async throws -> User {
        do {
            let user = try await online.getUser(id: id)
            try? storage.save(user, forKey: "user_\(id)")
            return user
        } catch {
            if let cached: User = storage.load(forKey: "user_\(id)") {
                return cached
            }
            throw error
        }
    }
    
    func updateUser(id: String, request: UserUpdateRequest) async throws -> User {
        try await online.updateUser(id: id, request: request)
    }
    
    func deleteUser(id: String) async throws {
        try await online.deleteUser(id: id)
        storage.remove(forKey: "user_\(id)")
    }
    
    func listUsers(page: Int, limit: Int) async throws -> PaginatedResponse<User> {
        do {
            let response = try await online.listUsers(page: page, limit: limit)
            try? storage.save(response, forKey: "users_page_\(page)")
            return response
        } catch {
            if let cached: PaginatedResponse<User> = storage.load(forKey: "users_page_\(page)") {
                return cached
            }
            throw error
        }
    }
    
    func searchUsers(query: String) async throws -> [User] {
        try await online.searchUsers(query: query)
    }
}

protocol LocalStorage {
    func save<T: Encodable>(_ value: T, forKey key: String) throws
    func load<T: Decodable>(forKey key: String) -> T?
    func remove(forKey key: String)
}

final class FileStorage: LocalStorage {
    private let directory: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.directory = documentsDirectory.appendingPathComponent("Cache")
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    }
    
    func save<T: Encodable>(_ value: T, forKey key: String) throws {
        let url = directory.appendingPathComponent(key)
        let data = try encoder.encode(value)
        try data.write(to: url)
    }
    
    func load<T: Decodable>(forKey key: String) -> T? {
        let url = directory.appendingPathComponent(key)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? decoder.decode(T.self, from: data)
    }
    
    func remove(forKey key: String) {
        let url = directory.appendingPathComponent(key)
        try? FileManager.default.removeItem(at: url)
    }
}

// MARK: - WebSocket Manager (Observer Pattern)

protocol WebSocketDelegate: AnyObject {
    func webSocket(_ manager: WebSocketManager, didReceive message: WebSocketMessage)
    func webSocket(_ manager: WebSocketManager, didChangeState state: WebSocketState)
    func webSocket(_ manager: WebSocketManager, didEncounterError error: Error)
}

enum WebSocketState {
    case disconnected
    case connecting
    case connected
    case disconnecting
}

struct WebSocketMessage {
    let type: String
    let payload: [String: Any]
    let timestamp: Date
}

final class WebSocketManager: NSObject {
    private var webSocketTask: URLSessionWebSocketTask?
    private let url: URL
    private let session: URLSession
    
    private var delegates = NSHashTable<AnyObject>.weakObjects()
    private(set) var state: WebSocketState = .disconnected {
        didSet {
            notifyDelegates { $0.webSocket(self, didChangeState: state) }
        }
    }
    
    private var reconnectAttempts = 0
    private let maxReconnectAttempts = 5
    private var pingTimer: Timer?
    
    init(url: URL, session: URLSession = .shared) {
        self.url = url
        self.session = session
        super.init()
    }
    
    func addDelegate(_ delegate: WebSocketDelegate) {
        delegates.add(delegate)
    }
    
    func removeDelegate(_ delegate: WebSocketDelegate) {
        delegates.remove(delegate)
    }
    
    func connect() {
        guard state == .disconnected else { return }
        
        state = .connecting
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        
        state = .connected
        reconnectAttempts = 0
        startReceiving()
        startPingTimer()
    }
    
    func disconnect() {
        state = .disconnecting
        stopPingTimer()
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        webSocketTask = nil
        state = .disconnected
    }
    
    func send(_ message: String) {
        let wsMessage = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(wsMessage) { [weak self] error in
            if let error = error {
                self?.handleError(error)
            }
        }
    }
    
    func send(_ data: Data) {
        let wsMessage = URLSessionWebSocketTask.Message.data(data)
        webSocketTask?.send(wsMessage) { [weak self] error in
            if let error = error {
                self?.handleError(error)
            }
        }
    }
    
    private func startReceiving() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let message):
                self.handleMessage(message)
                self.startReceiving()
                
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
    private func handleMessage(_ message: URLSessionWebSocketTask.Message) {
        let wsMessage: WebSocketMessage
        
        switch message {
        case .string(let text):
            guard let data = text.data(using: .utf8),
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                return
            }
            wsMessage = WebSocketMessage(
                type: json["type"] as? String ?? "unknown",
                payload: json["payload"] as? [String: Any] ?? [:],
                timestamp: Date()
            )
            
        case .data(let data):
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                return
            }
            wsMessage = WebSocketMessage(
                type: json["type"] as? String ?? "unknown",
                payload: json["payload"] as? [String: Any] ?? [:],
                timestamp: Date()
            )
            
        @unknown default:
            return
        }
        
        notifyDelegates { $0.webSocket(self, didReceive: wsMessage) }
    }
    
    private func handleError(_ error: Error) {
        notifyDelegates { $0.webSocket(self, didEncounterError: error) }
        
        if state == .connected {
            attemptReconnect()
        }
    }
    
    private func attemptReconnect() {
        guard reconnectAttempts < maxReconnectAttempts else {
            state = .disconnected
            return
        }
        
        reconnectAttempts += 1
        let delay = Double(reconnectAttempts) * 2.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.connect()
        }
    }
    
    private func startPingTimer() {
        pingTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.webSocketTask?.sendPing { error in
                if let error = error {
                    self?.handleError(error)
                }
            }
        }
    }
    
    private func stopPingTimer() {
        pingTimer?.invalidate()
        pingTimer = nil
    }
    
    private func notifyDelegates(_ action: (WebSocketDelegate) -> Void) {
        delegates.allObjects.compactMap { $0 as? WebSocketDelegate }.forEach(action)
    }
}

// MARK: - Request Queue (Command Pattern)

protocol NetworkCommand {
    var id: UUID { get }
    var priority: RequestPriority { get }
    var retryCount: Int { get set }
    var maxRetries: Int { get }
    
    func execute() async throws
    func cancel()
}

enum RequestPriority: Int, Comparable {
    case low = 0
    case normal = 1
    case high = 2
    case critical = 3
    
    static func < (lhs: RequestPriority, rhs: RequestPriority) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

final class RequestQueue {
    private var queue: [NetworkCommand] = []
    private var runningCommands: Set<UUID> = []
    private let maxConcurrentRequests: Int
    private let lock = NSLock()
    
    init(maxConcurrentRequests: Int = 4) {
        self.maxConcurrentRequests = maxConcurrentRequests
    }
    
    func enqueue(_ command: NetworkCommand) {
        lock.lock()
        defer { lock.unlock() }
        
        queue.append(command)
        queue.sort { $0.priority > $1.priority }
        
        processQueue()
    }
    
    func cancel(id: UUID) {
        lock.lock()
        defer { lock.unlock() }
        
        if let index = queue.firstIndex(where: { $0.id == id }) {
            queue[index].cancel()
            queue.remove(at: index)
        }
    }
    
    func cancelAll() {
        lock.lock()
        defer { lock.unlock() }
        
        queue.forEach { $0.cancel() }
        queue.removeAll()
    }
    
    private func processQueue() {
        guard runningCommands.count < maxConcurrentRequests else { return }
        guard !queue.isEmpty else { return }
        
        let command = queue.removeFirst()
        runningCommands.insert(command.id)
        
        Task {
            do {
                try await command.execute()
            } catch {
                var mutableCommand = command
                if mutableCommand.retryCount < mutableCommand.maxRetries {
                    mutableCommand.retryCount += 1
                    enqueue(mutableCommand)
                }
            }
            
            lock.lock()
            runningCommands.remove(command.id)
            lock.unlock()
            
            processQueue()
        }
    }
}

// MARK: - Concrete Network Command

final class FetchUserCommand: NetworkCommand {
    let id = UUID()
    let priority: RequestPriority
    var retryCount = 0
    let maxRetries = 3
    
    private let userId: String
    private let repository: UserRepository
    private let completion: (Result<User, Error>) -> Void
    private var isCancelled = false
    
    init(
        userId: String,
        priority: RequestPriority = .normal,
        repository: UserRepository,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        self.userId = userId
        self.priority = priority
        self.repository = repository
        self.completion = completion
    }
    
    func execute() async throws {
        guard !isCancelled else { return }
        
        do {
            let user = try await repository.getUser(id: userId)
            completion(.success(user))
        } catch {
            completion(.failure(error))
            throw error
        }
    }
    
    func cancel() {
        isCancelled = true
    }
}
