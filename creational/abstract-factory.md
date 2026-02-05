# Abstract Factory Pattern

> Create families of related objects without specifying concrete classes

## Problem

You need to create families of related objects that work together:
- UI themes (light/dark with consistent buttons, labels, backgrounds)
- Platform-specific UI components
- Database implementations with related entities

## Solution

```swift
// MARK: - Abstract Products
protocol Button {
    var backgroundColor: Color { get }
    var textColor: Color { get }
    func render() -> some View
}

protocol TextField {
    var borderColor: Color { get }
    var backgroundColor: Color { get }
    func render() -> some View
}

protocol Card {
    var shadowColor: Color { get }
    var backgroundColor: Color { get }
    func render() -> some View
}

// MARK: - Abstract Factory
protocol ThemeFactory {
    func createButton() -> Button
    func createTextField() -> TextField
    func createCard() -> Card
}

// MARK: - Light Theme Products
class LightButton: Button {
    let backgroundColor = Color.blue
    let textColor = Color.white
    
    func render() -> some View {
        Text("Button")
            .padding()
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(8)
    }
}

class LightTextField: TextField {
    let borderColor = Color.gray.opacity(0.3)
    let backgroundColor = Color.white
    
    func render() -> some View {
        SwiftUI.TextField("Enter text", text: .constant(""))
            .padding()
            .background(backgroundColor)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(borderColor))
    }
}

class LightCard: Card {
    let shadowColor = Color.black.opacity(0.1)
    let backgroundColor = Color.white
    
    func render() -> some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(backgroundColor)
            .shadow(color: shadowColor, radius: 4)
    }
}

// MARK: - Dark Theme Products
class DarkButton: Button {
    let backgroundColor = Color.purple
    let textColor = Color.white
    
    func render() -> some View {
        Text("Button")
            .padding()
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(12)
    }
}

class DarkTextField: TextField {
    let borderColor = Color.purple.opacity(0.5)
    let backgroundColor = Color.gray.opacity(0.2)
    
    func render() -> some View {
        SwiftUI.TextField("Enter text", text: .constant(""))
            .padding()
            .background(backgroundColor)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(borderColor))
    }
}

class DarkCard: Card {
    let shadowColor = Color.purple.opacity(0.3)
    let backgroundColor = Color.gray.opacity(0.2)
    
    func render() -> some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(backgroundColor)
            .shadow(color: shadowColor, radius: 8)
    }
}

// MARK: - Concrete Factories
class LightThemeFactory: ThemeFactory {
    func createButton() -> Button { LightButton() }
    func createTextField() -> TextField { LightTextField() }
    func createCard() -> Card { LightCard() }
}

class DarkThemeFactory: ThemeFactory {
    func createButton() -> Button { DarkButton() }
    func createTextField() -> TextField { DarkTextField() }
    func createCard() -> Card { DarkCard() }
}

// MARK: - Factory Provider
class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: ThemeFactory = LightThemeFactory()
    
    func setTheme(_ style: ThemeStyle) {
        switch style {
        case .light:
            currentTheme = LightThemeFactory()
        case .dark:
            currentTheme = DarkThemeFactory()
        case .system:
            let isDark = UITraitCollection.current.userInterfaceStyle == .dark
            currentTheme = isDark ? DarkThemeFactory() : LightThemeFactory()
        }
    }
}

enum ThemeStyle {
    case light, dark, system
}

// MARK: - Usage
struct ThemedView: View {
    @ObservedObject var themeManager = ThemeManager.shared
    
    var body: some View {
        let factory = themeManager.currentTheme
        
        VStack {
            factory.createCard().render()
                .frame(height: 100)
            factory.createTextField().render()
            factory.createButton().render()
        }
        .padding()
    }
}
```

## When to Use ✅

- Create families of related objects
- Products must be used together
- Want to swap entire families at once
- Hide concrete implementations

## When NOT to Use ❌

- Products don't relate to each other
- Only one product family exists
- Simpler factory method suffices

## Related Patterns

- **Factory Method**: Simpler, creates single products
- **Builder**: For step-by-step construction
- **Singleton**: Factory itself often singleton
