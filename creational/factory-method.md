# Factory Method Pattern

> Define interface for creating objects, let subclasses decide which class to instantiate

## Problem

You need to create objects but:
- Don't know the exact class until runtime
- Want to delegate instantiation to subclasses
- Need platform-specific implementations

## Solution

```swift
// MARK: - Product Protocol
protocol PaymentProcessor {
    func processPayment(amount: Decimal) async throws -> PaymentResult
    var name: String { get }
    var icon: String { get }
}

// MARK: - Concrete Products
class CreditCardProcessor: PaymentProcessor {
    let name = "Credit Card"
    let icon = "creditcard.fill"
    
    func processPayment(amount: Decimal) async throws -> PaymentResult {
        try await StripeAPI.charge(amount: amount)
        return PaymentResult(success: true, transactionId: UUID().uuidString)
    }
}

class ApplePayProcessor: PaymentProcessor {
    let name = "Apple Pay"
    let icon = "apple.logo"
    
    func processPayment(amount: Decimal) async throws -> PaymentResult {
        let controller = PKPaymentAuthorizationController(paymentRequest: createRequest(amount))
        return try await controller.present()
    }
}

class PayPalProcessor: PaymentProcessor {
    let name = "PayPal"
    let icon = "p.circle.fill"
    
    func processPayment(amount: Decimal) async throws -> PaymentResult {
        try await PayPalAPI.checkout(amount: amount)
    }
}

// MARK: - Factory
enum PaymentMethod {
    case creditCard
    case applePay
    case payPal
}

class PaymentProcessorFactory {
    static func create(_ method: PaymentMethod) -> PaymentProcessor {
        switch method {
        case .creditCard:
            return CreditCardProcessor()
        case .applePay:
            return ApplePayProcessor()
        case .payPal:
            return PayPalProcessor()
        }
    }
    
    static func availableProcessors() -> [PaymentProcessor] {
        var processors: [PaymentProcessor] = [CreditCardProcessor()]
        
        if PKPaymentAuthorizationController.canMakePayments() {
            processors.append(ApplePayProcessor())
        }
        
        if PayPalAPI.isAvailable {
            processors.append(PayPalProcessor())
        }
        
        return processors
    }
}

// MARK: - Usage
class CheckoutViewModel: ObservableObject {
    @Published var selectedMethod: PaymentMethod = .creditCard
    @Published var availableMethods: [PaymentProcessor] = []
    
    init() {
        availableMethods = PaymentProcessorFactory.availableProcessors()
    }
    
    func pay(amount: Decimal) async throws {
        let processor = PaymentProcessorFactory.create(selectedMethod)
        let result = try await processor.processPayment(amount: amount)
    }
}
```

## Platform-Specific Factory

```swift
protocol PlatformButton {
    func render() -> some View
}

class IOSButton: PlatformButton {
    func render() -> some View {
        Button("iOS Style") {}
            .buttonStyle(.borderedProminent)
    }
}

class MacOSButton: PlatformButton {
    func render() -> some View {
        Button("macOS Style") {}
            .controlSize(.large)
    }
}

class ButtonFactory {
    static func create() -> PlatformButton {
        #if os(iOS)
        return IOSButton()
        #elseif os(macOS)
        return MacOSButton()
        #endif
    }
}
```

## When to Use ✅

- Class doesn't know which objects to create
- Subclasses should specify objects
- Want to localize object creation logic
- Platform-specific implementations needed

## When NOT to Use ❌

- Single implementation exists
- Factory adds unnecessary complexity
- Direct instantiation is clearer

## Common Mistakes

```swift
// ❌ WRONG: Factory knows too much
class BadFactory {
    func create(type: String) -> Any? {
        switch type {
        case "user": return User()
        case "post": return Post()
        case "comment": return Comment()
        // Endless switch for unrelated types
        }
    }
}

// ✅ CORRECT: Focused factory
class UserFactory {
    func create(type: UserType) -> User {
        switch type {
        case .regular: return RegularUser()
        case .premium: return PremiumUser()
        case .admin: return AdminUser()
        }
    }
}
```

## Related Patterns

- **Abstract Factory**: Create families of related objects
- **Builder**: Construct complex objects step by step
- **Prototype**: Clone existing objects
