<div align="center">

```
╔═══════════════════════════════════════════════════════════════════════════════╗
║  __  __       _     _ _        ____            _                              ║
║ |  \/  | ___ | |__ (_) | ___  |  _ \  ___  ___(_) __ _ _ __                   ║
║ | |\/| |/ _ \| '_ \| | |/ _ \ | | | |/ _ \/ __| |/ _` | '_ \                  ║
║ | |  | | (_) | |_) | | |  __/ | |_| |  __/\__ \ | (_| | | | |                 ║
║ |_|  |_|\___/|_.__/|_|_|\___| |____/ \___||___/_|\__, |_| |_|                 ║
║                                                   |___/                        ║
║  ____       _   _                                                             ║
║ |  _ \ __ _| |_| |_ ___ _ __ _ __  ___                                        ║
║ | |_) / _` | __| __/ _ \ '__| '_ \/ __|                                       ║
║ |  __/ (_| | |_| ||  __/ |  | | | \__ \                                       ║
║ |_|   \__,_|\__|\__\___|_|  |_| |_|___/                                       ║
║                                                                                ║
╚═══════════════════════════════════════════════════════════════════════════════╝
```

# Mobile Design Patterns

**A comprehensive guide to design patterns for iOS and Android development**

[![Design Patterns](https://img.shields.io/badge/Design-Patterns-purple?style=flat-square)](https://en.wikipedia.org/wiki/Software_design_pattern)
[![iOS](https://img.shields.io/badge/iOS-Swift-orange?style=flat-square&logo=swift)](https://swift.org)
[![Android](https://img.shields.io/badge/Android-Kotlin-green?style=flat-square&logo=kotlin)](https://kotlinlang.org)
![GitHub stars](https://img.shields.io/github/stars/muhittincamdali/mobile-design-patterns?style=flat-square&color=yellow)
![GitHub forks](https://img.shields.io/github/forks/muhittincamdali/mobile-design-patterns?style=flat-square)
![GitHub last commit](https://img.shields.io/github/last-commit/muhittincamdali/mobile-design-patterns?style=flat-square&color=blue)
![GitHub contributors](https://img.shields.io/github/contributors/muhittincamdali/mobile-design-patterns?style=flat-square&color=green)
[![License](https://img.shields.io/github/license/muhittincamdali/mobile-design-patterns?style=flat-square)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

[Creational](#-creational-patterns) •
[Structural](#-structural-patterns) •
[Behavioral](#-behavioral-patterns) •
[Mobile-Specific](#-mobile-specific-patterns)

</div>

---

## 📖 Overview

Design patterns are proven solutions to common software design problems. This repository provides mobile-focused implementations with Swift and Kotlin examples, helping you build maintainable, scalable apps.

## 📑 Table of Contents

- [Overview](#-overview)
- [Creational Patterns](#-creational-patterns)
- [Structural Patterns](#-structural-patterns)
- [Behavioral Patterns](#-behavioral-patterns)
- [Mobile-Specific Patterns](#-mobile-specific-patterns)
- [Pattern Selection Guide](#-pattern-selection-guide)
- [Contributing](#-contributing)
- [License](#-license)

## 🏗️ Creational Patterns

*Patterns for object creation mechanisms*

| Pattern | Purpose | iOS | Android |
|---------|---------|-----|---------|
| **Singleton** | Single instance | ✅ | ✅ |
| **Factory Method** | Object creation interface | ✅ | ✅ |
| **Abstract Factory** | Family of objects | ✅ | ✅ |
| **Builder** | Complex object construction | ✅ | ✅ |
| **Prototype** | Clone objects | ✅ | ✅ |

### Singleton Example

```swift
// iOS - Swift
final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
}
```

```kotlin
// Android - Kotlin
object NetworkManager {
    fun makeRequest() { /* ... */ }
}
```

## 🧱 Structural Patterns

*Patterns for composing classes and objects*

| Pattern | Purpose | iOS | Android |
|---------|---------|-----|---------|
| **Adapter** | Interface conversion | ✅ | ✅ |
| **Bridge** | Abstraction separation | ✅ | ✅ |
| **Composite** | Tree structures | ✅ | ✅ |
| **Decorator** | Dynamic behavior | ✅ | ✅ |
| **Facade** | Simplified interface | ✅ | ✅ |
| **Proxy** | Access control | ✅ | ✅ |

### Adapter Example

```swift
// iOS - Swift
protocol MediaPlayer {
    func play(filename: String)
}

class AudioAdapter: MediaPlayer {
    private let advancedPlayer: AdvancedMediaPlayer
    
    func play(filename: String) {
        advancedPlayer.playAdvanced(filename)
    }
}
```

## 🔄 Behavioral Patterns

*Patterns for object communication*

| Pattern | Purpose | iOS | Android |
|---------|---------|-----|---------|
| **Observer** | Event subscription | ✅ | ✅ |
| **Strategy** | Algorithm family | ✅ | ✅ |
| **Command** | Request encapsulation | ✅ | ✅ |
| **State** | State-based behavior | ✅ | ✅ |
| **Chain of Responsibility** | Request handling chain | ✅ | ✅ |
| **Mediator** | Object interaction | ✅ | ✅ |

### Observer Example

```swift
// iOS - Using Combine
class ViewModel: ObservableObject {
    @Published var data: [Item] = []
}
```

```kotlin
// Android - Using Flow
class ViewModel : ViewModel() {
    private val _data = MutableStateFlow<List<Item>>(emptyList())
    val data: StateFlow<List<Item>> = _data.asStateFlow()
}
```

## 📱 Mobile-Specific Patterns

*Patterns designed for mobile development*

| Pattern | Purpose | Platform |
|---------|---------|----------|
| **Repository** | Data abstraction | Both |
| **Coordinator** | Navigation management | iOS |
| **UseCase/Interactor** | Business logic | Both |
| **ViewModel** | UI state management | Both |
| **Dependency Injection** | Loose coupling | Both |

### Repository Pattern

```swift
// iOS
protocol UserRepository {
    func getUser(id: String) async throws -> User
    func saveUser(_ user: User) async throws
}

class UserRepositoryImpl: UserRepository {
    private let remote: RemoteDataSource
    private let local: LocalDataSource
    
    func getUser(id: String) async throws -> User {
        if let cached = try? await local.getUser(id) {
            return cached
        }
        return try await remote.fetchUser(id)
    }
}
```

## 🎯 Pattern Selection Guide

```
┌─────────────────────────────────────────────────────────────┐
│                 WHICH PATTERN DO I NEED?                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Need single instance? ───────────────────► Singleton       │
│                                                             │
│  Complex object creation? ────────────────► Builder         │
│                                                             │
│  Want to notify multiple objects? ────────► Observer        │
│                                                             │
│  Need to switch algorithms? ──────────────► Strategy        │
│                                                             │
│  Managing UI state? ──────────────────────► ViewModel       │
│                                                             │
│  Abstracting data sources? ───────────────► Repository      │
│                                                             │
│  Handling navigation? ────────────────────► Coordinator     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## 📚 Resources

- **Books**
  - Design Patterns (Gang of Four)
  - Head First Design Patterns
  - Clean Architecture

- **Documentation**
  - [Apple Developer](https://developer.apple.com)
  - [Android Developers](https://developer.android.com)

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md).

1. Fork the repository
2. Add your pattern or improvement
3. Include both iOS and Android examples
4. Submit a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Muhittin Camdali**
- GitHub: [@muhittincamdali](https://github.com/muhittincamdali)

---

<div align="center">

### ⭐ Star History

[![Star History Chart](https://api.star-history.com/svg?repos=muhittincamdali/mobile-design-patterns&type=Date)](https://star-history.com/#muhittincamdali/mobile-design-patterns&Date)

**If you found this useful, please ⭐ star this repository!**

</div>
