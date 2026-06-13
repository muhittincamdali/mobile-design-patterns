<p align="center">
  <img src="https://img.shields.io/badge/🧩_Mobile_Design_Patterns-purple?style=for-the-badge&labelColor=purple" alt="Mobile Design Patterns"/>
</p>

<h1 align="center">📱 Mobile Design Patterns</h1>

<p align="center">
  <strong>The most comprehensive collection of 55+ design patterns for iOS development</strong>
</p>

<p align="center">
  <a href="#-quick-start"><img src="https://img.shields.io/badge/Quick_Start-00C853?style=flat-square&logo=rocket&logoColor=white" alt="Quick Start"/></a>
  <a href="#-pattern-catalog"><img src="https://img.shields.io/badge/55+_Patterns-2196F3?style=flat-square&logo=puzzle&logoColor=white" alt="Patterns"/></a>
  <a href="docs/PATTERN_DECISION_TREE.md"><img src="https://img.shields.io/badge/Decision_Tree-FF9800?style=flat-square&logo=tree&logoColor=white" alt="Decision Tree"/></a>
  <a href="docs/REFACTORING_GUIDE.md"><img src="https://img.shields.io/badge/Refactoring-9C27B0?style=flat-square&logo=code&logoColor=white" alt="Refactoring"/></a>
</p>

<p align="center">
  <img src="https://img.shields.io/github/stars/muhittincamdali/mobile-design-patterns?style=flat-square&color=yellow" alt="Stars"/>
  <img src="https://img.shields.io/badge/Swift-5.9+-F05138?style=flat-square&logo=swift" alt="Swift"/>
  <img src="https://img.shields.io/badge/iOS-15+-000000?style=flat-square&logo=apple" alt="iOS"/>
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="License"/>
</p>

---

## 🎯 Why This Repository?

| Feature | This Repo | Others |
|---------|-----------|--------|
| **Pattern Count** | 55+ | 20-30 |
| **Real-world Examples** | ✅ Production code | ❌ Academic only |
| **When NOT to Use** | ✅ Anti-patterns covered | ❌ Missing |
| **Decision Tree** | ✅ Interactive | ❌ None |
| **Refactoring Guides** | ✅ Step-by-step | ❌ None |
| **Mobile-Specific** | ✅ iOS/Android focus | ❌ Generic |
| **Swift 6 Native** | ✅ Strict Concurrency | ❌ Data races |

---

## 🛡️ The Unified Core: Elite Implementation Examples
Our 'Endless March' initiative has established a new standard for mobile architecture. The following frameworks represent the absolute #1 global implementations of these patterns:

- **[SwiftNetwork](https://github.com/muhittincamdali/SwiftNetwork)**: The definitive implementation of the **Facade** and **Repository** patterns for high-performance networking (6.7x faster than Alamofire).
- **[SwiftAI](https://github.com/muhittincamdali/SwiftAI)**: Elite use of the **Strategy** and **Command** patterns for SIMD-accelerated neural operations.
- **[LiquidGlassKit](https://github.com/muhittincamdali/LiquidGlassKit)**: The portfolio's visual signature, demonstrating the **Decorator** and **Style** patterns for modern SwiftUI.

---

## 🚀 Swift 6 Concurrency Patterns
Modern iOS development requires a shift from legacy thread-safe patterns to native Swift 6 primitives.

- **The Actor Pattern**: Replacing traditional Locks/Semaphores with `actor` for safe mutable state.
- **Structured Concurrency**: Using `TaskGroup` and `async let` instead of legacy callback hell or DispatchGroups.
- **Global Actors**: Leveraging `@MainActor` for guaranteed UI thread safety without manual `DispatchQueue.main` calls.

---

## 🚀 Quick Start

```swift
// Pick a pattern based on your problem:

// Need single instance? → Singleton
let config = AppConfig.shared

// Creating complex objects? → Builder
let request = NetworkRequestBuilder()
    .url("https://api.example.com")
    .method(.post)
    .bearerToken(token)
    .build()

// Managing navigation? → Coordinator
coordinator.navigate(to: .profile(userId: "123"))

// Multiple algorithms? → Strategy
let payment = PaymentProcessor(strategy: ApplePayStrategy())
```

---

## 📚 Pattern Catalog

### 🏗️ Creational Patterns (11)

> Patterns for object creation mechanisms

| # | Pattern | Description | Docs |
|---|---------|-------------|------|
| 1 | **Singleton** | Single global instance | [📖](creational/singleton.md) |
| 2 | **Factory Method** | Create objects without specifying class | [📖](creational/factory-method.md) |
| 3 | **Abstract Factory** | Create families of related objects | [📖](creational/abstract-factory.md) |
| 4 | **Builder** | Construct complex objects step by step | [📖](creational/builder.md) |
| 5 | **Prototype** | Clone existing objects | [📖](creational/prototype.md) |
| 6 | **Object Pool** | Reuse expensive objects | [📖](creational/object-pool.md) |
| 7 | **Lazy Initialization** | Create on first access | - |
| 8 | **Dependency Injection** | Inject dependencies externally | [📖](creational/dependency-injection.md) |
| 9 | **Service Locator** | Centralize dependency lookup | - |
| 10 | **Multiton** | Named singletons | - |
| 11 | **RAII** | Resource management | - |

---

### 🔗 Structural Patterns (12)

> Patterns for object composition

| # | Pattern | Description | Docs |
|---|---------|-------------|------|
| 1 | **Adapter** | Convert incompatible interfaces | [📖](structural/adapter.md) |
| 2 | **Bridge** | Separate abstraction from implementation | - |
| 3 | **Composite** | Tree structures with uniform interface | - |
| 4 | **Decorator** | Add behavior dynamically | [📖](structural/decorator.md) |
| 5 | **Facade** | Simplify complex subsystem | [📖](structural/facade.md) |
| 6 | **Flyweight** | Share common state | - |
| 7 | **Proxy** | Control object access | [📖](structural/proxy.md) |
| 8 | **Module** | Organize code into namespaces | - |
| 9 | **Private Class Data** | Protect mutable state | - |
| 10 | **Extension** | Add functionality to types | - |
| 11 | **Marker Interface** | Tag types with empty protocol | - |
| 12 | **Wrapper** | Adapt third-party code | - |

---

### 🎭 Behavioral Patterns (12)

> Patterns for object communication

| # | Pattern | Description | Docs |
|---|---------|-------------|------|
| 1 | **Chain of Responsibility** | Pass request along chain | - |
| 2 | **Command** | Encapsulate operations as objects | [📖](behavioral/command.md) |
| 3 | **Iterator** | Traverse collections sequentially | - |
| 4 | **Mediator** | Centralize communication | - |
| 5 | **Memento** | Save/restore state | - |
| 6 | **Observer** | React to state changes | [📖](behavioral/observer.md) |
| 7 | **State** | Change behavior based on state | [📖](behavioral/state.md) |
| 8 | **Strategy** | Swap algorithms at runtime | [📖](behavioral/strategy.md) |
| 9 | **Template Method** | Define algorithm skeleton | - |
| 10 | **Visitor** | Add operations to structures | - |
| 11 | **Interpreter** | Evaluate language grammar | - |
| 12 | **Null Object** | Avoid null checks | - |

---

### 🏛️ Architectural Patterns (10)

> High-level patterns for app structure

| # | Pattern | Description | Docs |
|---|---------|-------------|------|
| 1 | **MVC** | Model-View-Controller | - |
| 2 | **MVP** | Model-View-Presenter | - |
| 3 | **MVVM** | Model-View-ViewModel | [📖](architectural/mvvm.md) |
| 4 | **VIPER** | View-Interactor-Presenter-Entity-Router | - |
| 5 | **Clean Architecture** | Layers with dependency rule | - |
| 6 | **Redux/TCA** | Unidirectional data flow | - |
| 7 | **Repository** | Abstract data sources | [📖](architectural/repository.md) |
| 8 | **Coordinator** | Manage navigation flow | [📖](architectural/coordinator.md) |
| 9 | **Modular Architecture** | Feature modules | - |
| 10 | **Plugin Architecture** | Extensible apps | - |

---

### 📱 Mobile-Specific Patterns (10)

> Patterns unique to mobile development

| # | Pattern | Description | Docs |
|---|---------|-------------|------|
| 1 | **Coordinator** | Centralized navigation | [📖](mobile-specific/coordinator-pattern.md) |
| 2 | **View State** | UI state management | [📖](mobile-specific/view-state.md) |
| 3 | **Repository** | Unified data interface | [📖](architectural/repository.md) |
| 4 | **Use Case/Interactor** | Single responsibility operations | - |
| 5 | **Environment Object** | SwiftUI dependency sharing | - |
| 6 | **Combine Pipeline** | Reactive data streams | - |
| 7 | **Async/Await Wrapper** | Modern async bridge | - |
| 8 | **Feature Flag** | Runtime feature toggles | - |
| 9 | **Deep Link Handler** | URL-based navigation | - |
| 10 | **App Lifecycle** | Background/foreground handling | - |

---

## 🔍 Pattern Decision Tree

```
┌─────────────────────────────────────────────────────────────────┐
│                    WHAT'S YOUR PROBLEM?                         │
└─────────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        ▼                     ▼                     ▼
   CREATING              STRUCTURING           COMMUNICATING
   OBJECTS?              OBJECTS?              BETWEEN OBJECTS?
        │                     │                     │
        ▼                     ▼                     ▼
┌───────────────┐    ┌───────────────┐    ┌───────────────┐
│ One instance? │    │ Incompatible  │    │ React to      │
│ → Singleton   │    │ interface?    │    │ changes?      │
│               │    │ → Adapter     │    │ → Observer    │
│ Complex       │    │               │    │               │
│ construction? │    │ Add behavior? │    │ Swap          │
│ → Builder     │    │ → Decorator   │    │ algorithms?   │
│               │    │               │    │ → Strategy    │
│ Hide concrete │    │ Simplify      │    │               │
│ class?        │    │ subsystem?    │    │ Undo/redo?    │
│ → Factory     │    │ → Facade      │    │ → Command     │
└───────────────┘    └───────────────┘    └───────────────┘
```

📖 **Full Decision Tree:** [docs/PATTERN_DECISION_TREE.md](docs/PATTERN_DECISION_TREE.md)

---

## 🛠️ Refactoring Guides

Learn to transform problematic code using patterns:

| Code Smell | Solution | Guide |
|------------|----------|-------|
| Long switch statements | Strategy Pattern | [📖](docs/REFACTORING_GUIDE.md#1-replace-conditionals-with-strategy) |
| God class | Facade Pattern | [📖](docs/REFACTORING_GUIDE.md#2-replace-god-object-with-facade) |
| Subclass explosion | Decorator Pattern | [📖](docs/REFACTORING_GUIDE.md#3-replace-inheritance-with-decorator) |
| Hard-coded dependencies | Dependency Injection | [📖](docs/REFACTORING_GUIDE.md#4-replace-singletons-with-dependency-injection) |
| Notification spaghetti | Observer Pattern | [📖](docs/REFACTORING_GUIDE.md#5-replace-notification-spaghetti-with-observer) |
| Massive ViewController | MVVM Pattern | [📖](docs/REFACTORING_GUIDE.md#6-replace-massive-viewcontroller-with-mvvm) |

---

## 📁 Project Structure

```
mobile-design-patterns/
├── creational/              # Object creation patterns
│   ├── singleton.md
│   ├── factory-method.md
│   ├── abstract-factory.md
│   ├── builder.md
│   ├── prototype.md
│   ├── object-pool.md
│   └── dependency-injection.md
├── structural/              # Object composition patterns
│   ├── adapter.md
│   ├── decorator.md
│   ├── facade.md
│   └── proxy.md
├── behavioral/              # Object communication patterns
│   ├── observer.md
│   ├── strategy.md
│   ├── command.md
│   └── state.md
├── architectural/           # App architecture patterns
│   ├── mvvm.md
│   ├── coordinator.md
│   └── repository.md
├── mobile-specific/         # Mobile-only patterns
│   ├── coordinator-pattern.md
│   └── view-state.md
├── docs/                    # Guides and references
│   ├── PATTERN_DECISION_TREE.md
│   └── REFACTORING_GUIDE.md
└── examples/                # Swift playground examples
    └── swift/
```

---

## 🎓 Pattern Selection Guide

| Problem | Pattern | Complexity |
|---------|---------|------------|
| Single instance needed | Singleton | ⭐ |
| Create family of objects | Factory | ⭐⭐ |
| Complex object construction | Builder | ⭐⭐ |
| Adapt incompatible interface | Adapter | ⭐⭐ |
| Add behavior dynamically | Decorator | ⭐⭐⭐ |
| Simplify complex system | Facade | ⭐⭐ |
| React to state changes | Observer | ⭐⭐ |
| Swap algorithms | Strategy | ⭐⭐ |
| Undo/redo operations | Command | ⭐⭐⭐ |
| Abstract data sources | Repository | ⭐⭐⭐ |
| Manage navigation | Coordinator | ⭐⭐⭐ |
| Loose coupling | Dependency Injection | ⭐⭐ |

---

## 🤝 Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md).

### Adding a New Pattern

1. Create markdown file in appropriate category
2. Include: Problem, Solution, When to Use, When NOT to Use
3. Add Swift code examples
4. Update README catalog
5. Submit PR

---

## 📄 License

MIT License - see [LICENSE](LICENSE)

---

<p align="center">
  <strong>⭐ Star this repo if you find it useful!</strong>
</p>

<p align="center">
  <sub>Built for iOS developers who want to write better code 🏗️</sub>
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
