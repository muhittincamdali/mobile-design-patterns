# Proxy Pattern

> Provide surrogate or placeholder for another object

## Problem

- Need to control access to an object
- Want to add functionality without changing original
- Lazy loading of expensive resources

## Types of Proxies

1. **Virtual Proxy** - Lazy loading
2. **Protection Proxy** - Access control
3. **Remote Proxy** - Network object representation
4. **Caching Proxy** - Cache results

## Solution

### Virtual Proxy (Lazy Loading)

```swift
protocol Image {
    var width: Int { get }
    var height: Int { get }
    func render() -> UIImage
}

// Real object - expensive to create
class HighResolutionImage: Image {
    let width: Int
    let height: Int
    private let imageData: Data
    
    init(path: String) {
        print("Loading high-res image from disk: \(path)")
        let url = URL(fileURLWithPath: path)
        self.imageData = try! Data(contentsOf: url)
        let image = UIImage(data: imageData)!
        self.width = Int(image.size.width)
        self.height = Int(image.size.height)
    }
    
    func render() -> UIImage {
        UIImage(data: imageData)!
    }
}

// Proxy - defers loading until needed
class ImageProxy: Image {
    private let path: String
    private var realImage: HighResolutionImage?
    
    let width: Int
    let height: Int
    
    init(path: String, width: Int, height: Int) {
        self.path = path
        self.width = width
        self.height = height
    }
    
    func render() -> UIImage {
        if realImage == nil {
            realImage = HighResolutionImage(path: path)
        }
        return realImage!.render()
    }
}

// Usage
class ImageGallery {
    private var images: [Image] = []
    
    func loadGallery(from manifest: GalleryManifest) {
        images = manifest.items.map { item in
            ImageProxy(path: item.path, width: item.width, height: item.height)
        }
    }
    
    func displayImage(at index: Int) -> UIImage {
        images[index].render()
    }
}
```

### Protection Proxy (Access Control)

```swift
protocol Document {
    var content: String { get }
    func edit(_ newContent: String) throws
    func delete() throws
}

class SecureDocument: Document {
    var content: String
    
    init(content: String) {
        self.content = content
    }
    
    func edit(_ newContent: String) throws {
        content = newContent
    }
    
    func delete() throws {
        content = ""
    }
}

class DocumentProxy: Document {
    private let document: SecureDocument
    private let user: User
    private let accessControl: AccessControlService
    
    init(document: SecureDocument, user: User, accessControl: AccessControlService) {
        self.document = document
        self.user = user
        self.accessControl = accessControl
    }
    
    var content: String {
        guard accessControl.canRead(user: user) else {
            return "[Access Denied]"
        }
        return document.content
    }
    
    func edit(_ newContent: String) throws {
        guard accessControl.canWrite(user: user) else {
            throw AccessError.writeNotAllowed
        }
        try document.edit(newContent)
    }
    
    func delete() throws {
        guard accessControl.canDelete(user: user) else {
            throw AccessError.deleteNotAllowed
        }
        try document.delete()
    }
}
```

### Caching Proxy

```swift
protocol WeatherService {
    func getWeather(for city: String) async throws -> Weather
}

class RealWeatherService: WeatherService {
    func getWeather(for city: String) async throws -> Weather {
        let url = URL(string: "https://api.weather.com/\(city)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Weather.self, from: data)
    }
}

class CachingWeatherProxy: WeatherService {
    private let service: WeatherService
    private var cache: [String: (weather: Weather, timestamp: Date)] = [:]
    private let cacheTTL: TimeInterval
    private let lock = NSLock()
    
    init(service: WeatherService, cacheTTL: TimeInterval = 300) {
        self.service = service
        self.cacheTTL = cacheTTL
    }
    
    func getWeather(for city: String) async throws -> Weather {
        lock.lock()
        if let cached = cache[city],
           Date().timeIntervalSince(cached.timestamp) < cacheTTL {
            lock.unlock()
            return cached.weather
        }
        lock.unlock()
        
        let weather = try await service.getWeather(for: city)
        
        lock.lock()
        cache[city] = (weather, Date())
        lock.unlock()
        
        return weather
    }
}
```

### Remote Proxy

```swift
protocol RemoteService {
    func execute(command: String) async throws -> String
}

class RemoteServiceProxy: RemoteService {
    private let serverURL: URL
    private let session: URLSession
    
    init(serverURL: URL) {
        self.serverURL = serverURL
        self.session = URLSession.shared
    }
    
    func execute(command: String) async throws -> String {
        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"
        request.httpBody = command.data(using: .utf8)
        
        let (data, _) = try await session.data(for: request)
        return String(data: data, encoding: .utf8) ?? ""
    }
}
```

## When to Use ✅

- Lazy initialization of expensive objects
- Access control
- Caching
- Logging/monitoring
- Remote object representation

## When NOT to Use ❌

- Simple objects without special needs
- Performance overhead is unacceptable
- Proxy logic is more complex than direct access

## Related Patterns

- **Adapter**: Changes interface, Proxy keeps same
- **Decorator**: Adds behavior, Proxy controls access
- **Facade**: Simplifies, Proxy represents
