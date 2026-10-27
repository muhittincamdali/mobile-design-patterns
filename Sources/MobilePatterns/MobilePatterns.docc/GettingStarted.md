# Getting started

Add the package, then use one pattern in one screen.

## Overview

Each type in MobilePatterns stands alone. You do not adopt a framework or a base class; you
pick the pattern that fixes the problem in front of you and leave the rest of the code as it
is.

### Add the package

In Xcode, choose **File › Add Package Dependencies…**, enter
`https://github.com/muhittincamdali/mobile-design-patterns` and add the **MobilePatterns**
library to your app target. In a `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/mobile-design-patterns", from: "2.0.0")
],
targets: [
    .target(name: "App", dependencies: [
        .product(name: "MobilePatterns", package: "mobile-design-patterns")
    ])
]
```

The package needs iOS 17 or macOS 14 and Swift 6.2 (Xcode 26) or later.

### Replace three loading flags with one value

A screen that keeps `isLoading`, `error` and `items` side by side can show a spinner and an
error at once, or lose its list while it refreshes. ``Loadable`` holds one of four states and
keeps the last value through a reload:

```swift
import MobilePatterns

@MainActor
@Observable
final class OrdersModel {
    private(set) var state: Loadable<[Order], OrdersError> = .idle

    func load(using api: OrdersAPI) async {
        state.startLoading()
        do {
            state.finish(with: .success(try await api.orders()))
        } catch {
            state.finish(with: .failure(.offline))
        }
    }
}
```

In the view, `state.value` is the list to show in every state, `state.isLoading` drives the
progress indicator and `state.failure` the error banner.

### Drive navigation from one place

Create one ``Router`` per `NavigationStack` and put it in the environment. Views call
``Router/push(_:)`` instead of building destinations, so a deep link can do the same:

```swift
enum AppRoute: Hashable { case orders, order(id: Int) }

struct RootView: View {
    @State private var router = Router<AppRoute>()

    var body: some View {
        NavigationStack(path: $router.path) {
            OrdersView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .orders: OrdersView()
                    case .order(let id): OrderView(id: id)
                    }
                }
        }
        .environment(router)
    }
}
```

### Run the example app

`Examples/PatternGallery` shows every pattern on its own screen on iOS and macOS. Its
`ReadmeSamples.swift` is also compiled and run by the package tests, so the samples in the
README stay correct.

## See Also

- <doc:ChoosingAPattern>
- <doc:LoadingDataWithViewState>
