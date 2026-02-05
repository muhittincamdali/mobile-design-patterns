# Refactoring Guide

> Step-by-step guides to refactor code using design patterns

## Common Refactoring Scenarios

### 1. Replace Conditionals with Strategy

**Before (Code Smell):**
```swift
class PaymentProcessor {
    func process(type: String, amount: Decimal) {
        switch type {
        case "credit_card":
            // 50 lines of credit card logic
        case "paypal":
            // 40 lines of PayPal logic
        case "apple_pay":
            // 30 lines of Apple Pay logic
        default:
            break
        }
    }
}
```

**After (Strategy Pattern):**
```swift
protocol PaymentStrategy {
    func process(amount: Decimal) async throws -> PaymentResult
}

class CreditCardStrategy: PaymentStrategy { ... }
class PayPalStrategy: PaymentStrategy { ... }
class ApplePayStrategy: PaymentStrategy { ... }

class PaymentProcessor {
    func process(strategy: PaymentStrategy, amount: Decimal) async throws -> PaymentResult {
        try await strategy.process(amount: amount)
    }
}
```

**Steps:**
1. Create protocol for the varying behavior
2. Extract each case into separate class
3. Replace switch with protocol method call
4. Inject strategy at call site

---

### 2. Replace God Object with Facade

**Before (Code Smell):**
```swift
class AppManager {
    func login() { }
    func logout() { }
    func fetchProducts() { }
    func addToCart() { }
    func checkout() { }
    func trackAnalytics() { }
    func sendNotification() { }
    // 50 more methods...
}
```

**After (Facade Pattern):**
```swift
class AuthFacade {
    func login() { }
    func logout() { }
}

class ShopFacade {
    func fetchProducts() { }
    func addToCart() { }
    func checkout() { }
}

class AppFacade {
    let auth = AuthFacade()
    let shop = ShopFacade()
    let analytics = AnalyticsFacade()
    let notifications = NotificationFacade()
}
```

**Steps:**
1. Identify logical groupings of methods
2. Create focused facade for each group
3. Move methods to appropriate facades
4. Create top-level facade if needed
5. Update all call sites

---

### 3. Replace Inheritance with Decorator

**Before (Code Smell):**
```swift
class Logger { }
class FileLogger: Logger { }
class EncryptedLogger: FileLogger { }
class CompressedEncryptedLogger: EncryptedLogger { }
class TimestampedCompressedEncryptedLogger: CompressedEncryptedLogger { }
// Explosion of subclasses!
```

**After (Decorator Pattern):**
```swift
protocol Logger {
    func log(_ message: String)
}

class FileLogger: Logger { ... }

class EncryptionDecorator: Logger {
    private let wrapped: Logger
    func log(_ message: String) {
        wrapped.log(encrypt(message))
    }
}

class CompressionDecorator: Logger { ... }
class TimestampDecorator: Logger { ... }

// Compose as needed
let logger = TimestampDecorator(
    CompressionDecorator(
        EncryptionDecorator(
            FileLogger()
        )
    )
)
```

**Steps:**
1. Extract common interface
2. Create base decorator with wrapped instance
3. Convert each inherited behavior to decorator
4. Compose decorators at construction time

---

### 4. Replace Singletons with Dependency Injection

**Before (Code Smell):**
```swift
class UserService {
    static let shared = UserService()
    private init() { }
}

class ProfileViewModel {
    func loadProfile() {
        UserService.shared.getUser() // Hard to test!
    }
}
```

**After (Dependency Injection):**
```swift
protocol UserServiceProtocol {
    func getUser() async throws -> User
}

class UserService: UserServiceProtocol { ... }

class ProfileViewModel {
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func loadProfile() async {
        try await userService.getUser() // Testable!
    }
}

// Production
let vm = ProfileViewModel(userService: UserService())

// Testing
let vm = ProfileViewModel(userService: MockUserService())
```

**Steps:**
1. Extract protocol from singleton
2. Add initializer parameter for dependency
3. Provide default value if backward compatibility needed
4. Update call sites
5. Create mocks for testing

---

### 5. Replace Notification Spaghetti with Observer

**Before (Code Smell):**
```swift
class CartManager {
    func addItem(_ item: Item) {
        items.append(item)
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
        UserDefaults.standard.set(items.count, forKey: "cartCount")
        BadgeManager.shared.updateBadge(items.count)
        AnalyticsManager.shared.track("item_added")
    }
}
```

**After (Observer Pattern):**
```swift
class CartManager: ObservableObject {
    @Published private(set) var items: [Item] = []
    
    func addItem(_ item: Item) {
        items.append(item)
    }
}

// Observers react to changes
class CartBadgeObserver {
    private var cancellable: AnyCancellable?
    
    init(cart: CartManager) {
        cancellable = cart.$items
            .map { $0.count }
            .sink { BadgeManager.updateBadge($0) }
    }
}

class CartAnalyticsObserver {
    private var cancellable: AnyCancellable?
    
    init(cart: CartManager) {
        cancellable = cart.$items
            .dropFirst()
            .sink { _ in Analytics.track("cart_updated") }
    }
}
```

**Steps:**
1. Make subject observable (@Published)
2. Remove direct calls to dependents
3. Create observer classes for each concern
4. Subscribe observers to subject

---

### 6. Replace Massive ViewController with MVVM

**Before (Code Smell):**
```swift
class ProfileViewController: UIViewController {
    // 500+ lines mixing:
    // - UI setup
    // - Network calls
    // - Data transformation
    // - Business logic
    // - Navigation
}
```

**After (MVVM):**
```swift
// ViewModel - Testable business logic
class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    
    private let userService: UserService
    
    func loadProfile() async { ... }
    
    var displayName: String { user?.name ?? "Unknown" }
}

// View - Only UI
struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    
    var body: some View {
        // Pure UI code
    }
}
```

**Steps:**
1. Create ViewModel class
2. Move state properties to ViewModel
3. Move business logic to ViewModel
4. Keep only UI code in View
5. Bind View to ViewModel

---

## Pattern Selection Guide

| Code Smell | Suggested Pattern |
|------------|------------------|
| Long switch statements | Strategy |
| God class (too many responsibilities) | Facade, Mediator |
| Subclass explosion | Decorator, Strategy |
| Scattered notification handling | Observer |
| Hard-coded dependencies | Dependency Injection |
| Complex object creation | Factory, Builder |
| State-dependent behavior | State |
| Navigation spaghetti | Coordinator |
| Massive view controller | MVVM, MVP |

## Refactoring Principles

1. **Single Responsibility** - Each class does one thing
2. **Open/Closed** - Open for extension, closed for modification
3. **Liskov Substitution** - Subtypes replaceable
4. **Interface Segregation** - Small, focused interfaces
5. **Dependency Inversion** - Depend on abstractions

## Testing After Refactoring

Always verify refactoring with tests:

```swift
// Before refactoring: Hard to test
func testPayment_beforeRefactoring() {
    // Can't mock PaymentProcessor internals
}

// After refactoring: Easy to test
func testPayment_afterRefactoring() {
    let mockStrategy = MockPaymentStrategy()
    mockStrategy.result = .success(PaymentResult())
    
    let processor = PaymentProcessor()
    let result = try await processor.process(strategy: mockStrategy, amount: 100)
    
    XCTAssertTrue(result.success)
    XCTAssertEqual(mockStrategy.processedAmount, 100)
}
```
