# Adapter Pattern

> Convert interface of a class into another interface clients expect

## Problem

- Have existing code with incompatible interface
- Need to use third-party library with different API
- Migrating between versions with API changes

## Solution

```swift
// MARK: - Target Interface (What client expects)
protocol ModernAnalytics {
    func track(event: AnalyticsEvent)
    func setUserProperty(_ key: String, value: Any)
    func logPurchase(_ purchase: Purchase)
}

struct AnalyticsEvent {
    let name: String
    let parameters: [String: Any]
    let timestamp: Date
}

// MARK: - Adaptee (Third-party SDK with different interface)
class LegacyFirebaseSDK {
    func logEvent(_ eventName: String, params: [String: NSObject]?) {
        print("Firebase: \(eventName) - \(params ?? [:])")
    }
    
    func setUserProperty(_ value: String?, forName name: String) {
        // Firebase user property
    }
    
    func logPurchase(currency: String, value: Double, items: [Any]) {
        // Firebase e-commerce
    }
}

// MARK: - Adapter
class FirebaseAnalyticsAdapter: ModernAnalytics {
    private let firebase: LegacyFirebaseSDK
    
    init(firebase: LegacyFirebaseSDK = LegacyFirebaseSDK()) {
        self.firebase = firebase
    }
    
    func track(event: AnalyticsEvent) {
        let params = event.parameters.compactMapValues { value -> NSObject? in
            switch value {
            case let string as String: return string as NSString
            case let number as Int: return number as NSNumber
            case let number as Double: return number as NSNumber
            case let bool as Bool: return bool as NSNumber
            default: return nil
            }
        }
        firebase.logEvent(event.name, params: params)
    }
    
    func setUserProperty(_ key: String, value: Any) {
        firebase.setUserProperty(String(describing: value), forName: key)
    }
    
    func logPurchase(_ purchase: Purchase) {
        firebase.logPurchase(
            currency: purchase.currency,
            value: purchase.amount,
            items: purchase.items.map { $0.toDictionary() }
        )
    }
}

// MARK: - Mixpanel Adapter
class MixpanelAdapter: ModernAnalytics {
    func track(event: AnalyticsEvent) {
        // Mixpanel.track(event.name, properties: event.parameters)
    }
    
    func setUserProperty(_ key: String, value: Any) {
        // Mixpanel.people.set(key, to: value)
    }
    
    func logPurchase(_ purchase: Purchase) {
        track(event: AnalyticsEvent(
            name: "Purchase",
            parameters: ["amount": purchase.amount, "currency": purchase.currency],
            timestamp: Date()
        ))
    }
}

// MARK: - Composite Adapter (Multiple Services)
class CompositeAnalyticsAdapter: ModernAnalytics {
    private let adapters: [ModernAnalytics]
    
    init(adapters: [ModernAnalytics]) {
        self.adapters = adapters
    }
    
    func track(event: AnalyticsEvent) {
        adapters.forEach { $0.track(event: event) }
    }
    
    func setUserProperty(_ key: String, value: Any) {
        adapters.forEach { $0.setUserProperty(key, value: value) }
    }
    
    func logPurchase(_ purchase: Purchase) {
        adapters.forEach { $0.logPurchase(purchase) }
    }
}

// MARK: - Usage
let analytics: ModernAnalytics = CompositeAnalyticsAdapter(adapters: [
    FirebaseAnalyticsAdapter(),
    MixpanelAdapter()
])

analytics.track(event: AnalyticsEvent(
    name: "button_tapped",
    parameters: ["button_id": "checkout", "screen": "cart"],
    timestamp: Date()
))
```

## Object vs Class Adapter

```swift
// Object Adapter (Composition - Preferred)
class ObjectAdapter: Target {
    private let adaptee: Adaptee
    
    init(adaptee: Adaptee) {
        self.adaptee = adaptee
    }
    
    func request() {
        adaptee.specificRequest()
    }
}

// Class Adapter (Inheritance - Less flexible)
class ClassAdapter: Adaptee, Target {
    func request() {
        specificRequest()
    }
}
```

## When to Use ✅

- Use existing class with incompatible interface
- Create reusable class working with unrelated classes
- Need to use several existing subclasses
- Wrapping third-party libraries

## When NOT to Use ❌

- Simple interface changes (use direct refactoring)
- Both interfaces are under your control
- Performance-critical code (adapter adds overhead)

## Related Patterns

- **Bridge**: Separates abstraction from implementation upfront
- **Decorator**: Adds functionality, same interface
- **Facade**: Simplifies complex subsystem
