# Observer Pattern

> Define subscription mechanism to notify objects about events

## Problem

- Objects need to be notified when state changes
- Don't want tight coupling between sender and receivers
- Number of observers can change at runtime

## Solution

### Classic Observer

```swift
// MARK: - Observer Protocol
protocol Observer: AnyObject {
    func update<T>(_ observable: Observable<T>, value: T)
}

// MARK: - Observable (Subject)
class Observable<T> {
    private var observers: [WeakObserver] = []
    
    var value: T {
        didSet { notifyObservers() }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func subscribe(_ observer: Observer) {
        observers.removeAll { $0.observer == nil }
        observers.append(WeakObserver(observer))
    }
    
    func unsubscribe(_ observer: Observer) {
        observers.removeAll { $0.observer === observer }
    }
    
    private func notifyObservers() {
        observers.forEach { $0.observer?.update(self, value: value) }
    }
    
    private class WeakObserver {
        weak var observer: Observer?
        init(_ observer: Observer) {
            self.observer = observer
        }
    }
}

// MARK: - Concrete Observer
class StockPriceDisplay: Observer {
    func update<T>(_ observable: Observable<T>, value: T) {
        if let price = value as? Double {
            print("Stock price updated: $\(String(format: "%.2f", price))")
        }
    }
}

// Usage
let stockPrice = Observable(150.0)
let display = StockPriceDisplay()
stockPrice.subscribe(display)
stockPrice.value = 155.50 // Triggers notification
```

### Closure-Based Observer

```swift
class EventEmitter<T> {
    typealias Handler = (T) -> Void
    
    private var handlers: [UUID: Handler] = [:]
    
    @discardableResult
    func on(_ handler: @escaping Handler) -> UUID {
        let id = UUID()
        handlers[id] = handler
        return id
    }
    
    func off(_ id: UUID) {
        handlers.removeValue(forKey: id)
    }
    
    func emit(_ value: T) {
        handlers.values.forEach { $0(value) }
    }
    
    func removeAll() {
        handlers.removeAll()
    }
}

// Usage
class UserService {
    let onLogin = EventEmitter<User>()
    let onLogout = EventEmitter<Void>()
    let onError = EventEmitter<Error>()
    
    func login(credentials: Credentials) async throws {
        do {
            let user = try await authenticate(credentials)
            onLogin.emit(user)
        } catch {
            onError.emit(error)
            throw error
        }
    }
}

// Subscribe
let userService = UserService()
let loginObserver = userService.onLogin.on { user in
    print("Welcome, \(user.name)!")
}

// Unsubscribe
userService.onLogin.off(loginObserver)
```

### Combine Publisher (Modern iOS)

```swift
import Combine

class SettingsManager: ObservableObject {
    @Published var theme: Theme = .system
    @Published var fontSize: CGFloat = 16
    @Published var notificationsEnabled = true
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $theme
            .dropFirst()
            .sink { theme in
                print("Theme changed to: \(theme)")
                UserDefaults.standard.set(theme.rawValue, forKey: "theme")
            }
            .store(in: &cancellables)
        
        $fontSize
            .dropFirst()
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { size in
                print("Font size changed to: \(size)")
            }
            .store(in: &cancellables)
    }
}

// SwiftUI integration
struct SettingsView: View {
    @ObservedObject var settings: SettingsManager
    
    var body: some View {
        Form {
            Picker("Theme", selection: $settings.theme) {
                ForEach(Theme.allCases, id: \.self) { theme in
                    Text(theme.name).tag(theme)
                }
            }
            
            Slider(value: $settings.fontSize, in: 12...24) {
                Text("Font Size: \(Int(settings.fontSize))")
            }
        }
    }
}
```

### Notification Center

```swift
extension Notification.Name {
    static let userDidLogin = Notification.Name("userDidLogin")
    static let cartDidUpdate = Notification.Name("cartDidUpdate")
}

class CartManager {
    static let shared = CartManager()
    
    private(set) var items: [CartItem] = [] {
        didSet {
            NotificationCenter.default.post(
                name: .cartDidUpdate,
                object: self,
                userInfo: ["items": items, "count": items.count]
            )
        }
    }
}

class CartBadgeViewModel {
    @Published var itemCount = 0
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = NotificationCenter.default
            .publisher(for: .cartDidUpdate)
            .compactMap { $0.userInfo?["count"] as? Int }
            .assign(to: \.itemCount, on: self)
    }
}
```

## Common Mistakes

```swift
// ❌ WRONG: Strong reference cycle
class BadObservable {
    var observers: [Observer] = [] // Strong reference - memory leak
}

// ✅ CORRECT: Weak references
class GoodObservable {
    private var observers: [WeakWrapper<Observer>] = []
}

// ❌ WRONG: NotificationCenter without cleanup
class BadViewController: UIViewController {
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, ...)
        // Never removed - memory leak!
    }
}

// ✅ CORRECT: Proper cleanup
class GoodViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        NotificationCenter.default
            .publisher(for: .someNotification)
            .sink { [weak self] _ in self?.handle() }
            .store(in: &cancellables)
    }
}
```

## When to Use ✅

- One-to-many dependency between objects
- Unknown number of observers
- Loose coupling needed
- Event-driven architecture

## When NOT to Use ❌

- Only one observer (use delegation)
- Synchronous response required
- Observer order matters critically

## Related Patterns

- **Mediator**: Centralizes communication
- **Singleton**: Observable often singleton
- **Command**: Can trigger observer updates
