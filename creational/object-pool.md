# Object Pool Pattern

> Reuse expensive objects instead of creating/destroying repeatedly

## Problem

- Object creation is expensive (database connections, heavy computations)
- Objects are needed frequently but briefly
- Creating/destroying causes performance issues

## Solution

```swift
// MARK: - Poolable Protocol
protocol Poolable: AnyObject {
    func reset()
}

// MARK: - Generic Object Pool
class ObjectPool<T: Poolable> {
    private var available: [T] = []
    private var inUse: Set<ObjectIdentifier> = []
    private let factory: () -> T
    private let maxSize: Int
    private let lock = NSLock()
    
    init(maxSize: Int = 10, factory: @escaping () -> T) {
        self.maxSize = maxSize
        self.factory = factory
    }
    
    func acquire() -> T {
        lock.lock()
        defer { lock.unlock() }
        
        let object: T
        if let reusable = available.popLast() {
            object = reusable
        } else {
            object = factory()
        }
        
        inUse.insert(ObjectIdentifier(object))
        return object
    }
    
    func release(_ object: T) {
        lock.lock()
        defer { lock.unlock() }
        
        guard inUse.remove(ObjectIdentifier(object)) != nil else { return }
        
        object.reset()
        
        if available.count < maxSize {
            available.append(object)
        }
    }
    
    var availableCount: Int {
        lock.lock()
        defer { lock.unlock() }
        return available.count
    }
    
    var inUseCount: Int {
        lock.lock()
        defer { lock.unlock() }
        return inUse.count
    }
}

// MARK: - Reusable Network Session
class ReusableNetworkSession: Poolable {
    private(set) var session: URLSession
    var requestCount = 0
    
    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.httpMaximumConnectionsPerHost = 5
        self.session = URLSession(configuration: config)
    }
    
    func reset() {
        requestCount = 0
    }
    
    func fetch(_ url: URL) async throws -> Data {
        requestCount += 1
        let (data, _) = try await session.data(from: url)
        return data
    }
}

// MARK: - Database Connection Pool
class DatabaseConnection: Poolable {
    private var connection: SQLiteConnection?
    var queryCount = 0
    
    init() {
        connection = SQLiteConnection(path: "app.db")
    }
    
    func reset() {
        queryCount = 0
        connection?.rollback()
    }
    
    func query(_ sql: String) -> [Row] {
        queryCount += 1
        return connection?.execute(sql) ?? []
    }
}

class DatabasePool {
    static let shared = ObjectPool<DatabaseConnection>(maxSize: 5) {
        DatabaseConnection()
    }
    
    static func withConnection<T>(_ block: (DatabaseConnection) throws -> T) rethrows -> T {
        let connection = shared.acquire()
        defer { shared.release(connection) }
        return try block(connection)
    }
}

// MARK: - Usage
let sessionPool = ObjectPool<ReusableNetworkSession>(maxSize: 3) {
    ReusableNetworkSession()
}

func fetchData() async throws -> Data {
    let session = sessionPool.acquire()
    defer { sessionPool.release(session) }
    
    return try await session.fetch(URL(string: "https://api.example.com/data")!)
}

// Database usage
let users = DatabasePool.withConnection { connection in
    connection.query("SELECT * FROM users")
}
```

## iOS TableViewCell Reuse (Built-in Pool)

```swift
class CustomCell: UITableViewCell {
    static let reuseIdentifier = "CustomCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset - this is the pool's reset()
        imageView?.image = nil
        textLabel?.text = nil
    }
}

// Register
tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.reuseIdentifier)

// Dequeue (acquire from pool)
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
        withIdentifier: CustomCell.reuseIdentifier,
        for: indexPath
    )
    return cell
}
```

## When to Use ✅

- Object creation is expensive
- High frequency create/destroy cycles
- Limited resources (connections, memory)
- Objects can be reset and reused

## When NOT to Use ❌

- Object creation is cheap
- Objects maintain important state
- Pool management overhead exceeds creation cost

## Related Patterns

- **Singleton**: Pool often managed as singleton
- **Flyweight**: Share intrinsic state across objects
- **Factory Method**: Pool uses factory to create objects
