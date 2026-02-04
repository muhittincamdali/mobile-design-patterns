<p align="center">
  <img src="Assets/banner.png" alt="Mobile Design Patterns" width="800"/>
</p>

<h1 align="center">Mobile Design Patterns</h1>

<p align="center">
  <strong>🧩 40+ design patterns implemented in Swift, Dart & TypeScript for mobile development</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/github/stars/muhittincamdali/mobile-design-patterns?style=flat-square" alt="Stars"/>
  <img src="https://img.shields.io/badge/patterns-40+-blue?style=flat-square" alt="Patterns"/>
  <img src="https://img.shields.io/badge/languages-3-orange?style=flat-square" alt="Languages"/>
</p>

---

## Contents

- [Creational Patterns](#creational-patterns)
- [Structural Patterns](#structural-patterns)
- [Behavioral Patterns](#behavioral-patterns)
- [Mobile-Specific Patterns](#mobile-specific-patterns)

---

## Creational Patterns

### Singleton

Ensure a class has only one instance.

```swift
// Swift
final class AppConfig {
    static let shared = AppConfig()
    private init() {}
    
    var apiKey: String = ""
    var environment: Environment = .production
}

// Usage
AppConfig.shared.apiKey = "xxx"
```

```dart
// Dart
class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();
  
  String apiKey = '';
}
```

**Use Cases:** Analytics, Configuration, Database connections

---

### Factory Method

Create objects without specifying exact class.

```swift
protocol Button {
    func render()
}

class IOSButton: Button {
    func render() { print("iOS Button") }
}

class AndroidButton: Button {
    func render() { print("Android Button") }
}

class ButtonFactory {
    static func create(for platform: Platform) -> Button {
        switch platform {
        case .iOS: return IOSButton()
        case .android: return AndroidButton()
        }
    }
}
```

**Use Cases:** Platform-specific widgets, Theme components

---

### Builder

Construct complex objects step by step.

```swift
class AlertBuilder {
    private var title: String?
    private var message: String?
    private var actions: [AlertAction] = []
    
    func title(_ title: String) -> AlertBuilder {
        self.title = title
        return self
    }
    
    func message(_ message: String) -> AlertBuilder {
        self.message = message
        return self
    }
    
    func addAction(_ action: AlertAction) -> AlertBuilder {
        actions.append(action)
        return self
    }
    
    func build() -> Alert {
        Alert(title: title, message: message, actions: actions)
    }
}

// Usage
let alert = AlertBuilder()
    .title("Error")
    .message("Something went wrong")
    .addAction(.ok)
    .addAction(.cancel)
    .build()
```

---

## Structural Patterns

### Adapter

Convert interface of a class into another expected interface.

```swift
// Legacy analytics
protocol LegacyAnalytics {
    func trackEvent(name: String, params: [String: String])
}

// New analytics protocol
protocol Analytics {
    func track(_ event: Event)
}

// Adapter
class AnalyticsAdapter: Analytics {
    private let legacy: LegacyAnalytics
    
    init(legacy: LegacyAnalytics) {
        self.legacy = legacy
    }
    
    func track(_ event: Event) {
        legacy.trackEvent(name: event.name, params: event.params)
    }
}
```

---

### Decorator

Add behavior to objects dynamically.

```swift
protocol Coffee {
    var cost: Double { get }
    var description: String { get }
}

class SimpleCoffee: Coffee {
    var cost: Double { 2.0 }
    var description: String { "Coffee" }
}

class MilkDecorator: Coffee {
    private let coffee: Coffee
    
    init(_ coffee: Coffee) { self.coffee = coffee }
    
    var cost: Double { coffee.cost + 0.5 }
    var description: String { coffee.description + " + Milk" }
}

// Usage
let coffee = MilkDecorator(SimpleCoffee())
print(coffee.description) // "Coffee + Milk"
print(coffee.cost) // 2.5
```

---

### Facade

Provide simplified interface to complex subsystem.

```swift
class MediaPlayerFacade {
    private let audioPlayer = AudioPlayer()
    private let videoPlayer = VideoPlayer()
    private let subtitleEngine = SubtitleEngine()
    
    func playMedia(_ file: MediaFile) {
        if file.hasVideo {
            videoPlayer.load(file.videoTrack)
        }
        audioPlayer.load(file.audioTrack)
        if let subs = file.subtitles {
            subtitleEngine.load(subs)
        }
        
        audioPlayer.play()
        videoPlayer.play()
        subtitleEngine.sync(with: audioPlayer)
    }
    
    func stop() {
        audioPlayer.stop()
        videoPlayer.stop()
        subtitleEngine.stop()
    }
}
```

---

## Behavioral Patterns

### Observer

Notify multiple objects about state changes.

```swift
protocol Observer: AnyObject {
    func update(_ value: Any)
}

class Observable<T> {
    private var observers: [Observer] = []
    
    var value: T {
        didSet { notifyObservers() }
    }
    
    init(_ value: T) { self.value = value }
    
    func subscribe(_ observer: Observer) {
        observers.append(observer)
    }
    
    private func notifyObservers() {
        observers.forEach { $0.update(value) }
    }
}
```

**SwiftUI Equivalent:** `@Published`, `@ObservedObject`

---

### Strategy

Define family of algorithms, make them interchangeable.

```swift
protocol PaymentStrategy {
    func pay(amount: Double) async throws -> PaymentResult
}

class CreditCardPayment: PaymentStrategy {
    func pay(amount: Double) async throws -> PaymentResult {
        // Credit card processing
    }
}

class ApplePayPayment: PaymentStrategy {
    func pay(amount: Double) async throws -> PaymentResult {
        // Apple Pay processing
    }
}

class PaymentProcessor {
    private let strategy: PaymentStrategy
    
    init(strategy: PaymentStrategy) {
        self.strategy = strategy
    }
    
    func processPayment(amount: Double) async throws -> PaymentResult {
        try await strategy.pay(amount: amount)
    }
}
```

---

### Command

Encapsulate request as an object.

```swift
protocol Command {
    func execute()
    func undo()
}

class AddTextCommand: Command {
    private let editor: TextEditor
    private let text: String
    
    init(editor: TextEditor, text: String) {
        self.editor = editor
        self.text = text
    }
    
    func execute() {
        editor.add(text)
    }
    
    func undo() {
        editor.removeLast(text.count)
    }
}

class CommandManager {
    private var history: [Command] = []
    
    func execute(_ command: Command) {
        command.execute()
        history.append(command)
    }
    
    func undo() {
        history.popLast()?.undo()
    }
}
```

---

## Mobile-Specific Patterns

### Repository

Abstract data sources.

```swift
protocol UserRepository {
    func getUser(id: String) async throws -> User
    func saveUser(_ user: User) async throws
}

class UserRepositoryImpl: UserRepository {
    private let remote: RemoteDataSource
    private let local: LocalDataSource
    
    func getUser(id: String) async throws -> User {
        if let cached = try? await local.getUser(id: id) {
            return cached
        }
        let user = try await remote.getUser(id: id)
        try await local.saveUser(user)
        return user
    }
}
```

---

### Coordinator

Manage navigation flow.

```swift
protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start()
}

class AppCoordinator: Coordinator {
    let navigationController: UINavigationController
    
    func start() {
        if isLoggedIn {
            showHome()
        } else {
            showLogin()
        }
    }
    
    func showLogin() {
        let vc = LoginViewController()
        vc.onLogin = { [weak self] in
            self?.showHome()
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showHome() {
        let coordinator = HomeCoordinator(navigationController: navigationController)
        coordinator.start()
    }
}
```

---

### Dependency Injection

Provide dependencies externally.

```swift
// Protocol
protocol NetworkService {
    func fetch<T: Decodable>(_ url: URL) async throws -> T
}

// Implementation
class URLSessionNetworkService: NetworkService {
    func fetch<T: Decodable>(_ url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

// Consumer
class UserViewModel {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) { // Injected
        self.networkService = networkService
    }
}

// Usage
let viewModel = UserViewModel(networkService: URLSessionNetworkService())
```

---

## Pattern Selection Guide

| Problem | Pattern |
|---------|---------|
| Single instance needed | Singleton |
| Create family of objects | Factory |
| Complex object construction | Builder |
| Adapt incompatible interface | Adapter |
| Add behavior dynamically | Decorator |
| Simplify complex system | Facade |
| React to state changes | Observer |
| Swap algorithms | Strategy |
| Undo/redo operations | Command |
| Abstract data sources | Repository |
| Manage navigation | Coordinator |
| Loose coupling | Dependency Injection |

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT License

---

<p align="center">
  <sub>Design patterns for better mobile apps 🏗️</sub>
</p>

---

## 📈 Star History

<a href="https://star-history.com/#muhittincamdali/mobile-design-patterns&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=muhittincamdali/mobile-design-patterns&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=muhittincamdali/mobile-design-patterns&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=muhittincamdali/mobile-design-patterns&type=Date" />
 </picture>
</a>
