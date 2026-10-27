<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-light.svg" alt="Mobile Design Patterns: Design patterns for iOS and macOS apps as tested Swift types, with Flutter and React Native ports."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/mobile-design-patterns/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/mobile-design-patterns/actions/workflows/ci.yml/badge.svg" alt="CI status"></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-light.svg" alt="Latest version: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-light.svg" alt="Supported platforms: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-light.svg" alt="Language version: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-light.svg" alt="License: MIT"></picture></a>
</p>

<p align="center">
<a href="#quick-start"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-en-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-en-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-en-light.svg" alt="Get started"></picture></a>
<a href="https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-en-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-en-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-en-light.svg" alt="Documentation"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-en-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-en-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-en-light.svg" alt="Examples"></picture></a>
</p>

<!-- brand:end -->

A Swift package of design patterns for iOS and macOS apps, written as small types you can use
one at a time: view state, state machine, coordinator and deep links, repository, decorators,
adapter, observer, command with undo, and builder. It is for app developers who know the
pattern names and want a version that holds up in a real app: one that refuses a second tap
while a payment runs, survives a completion handler called twice, and turns away a deep link
with `..` in its path. Every pattern has tests, the README samples compile and run as tests, and
an example app shows each one on screen. View state, the state machine and undo also come as
Flutter and React Native packages.

## Highlights

- **One type per pattern** — `Loadable`, `StateMachine`, `Router`, `DeepLinkParser`,
  `Repository`, `AsyncLoader`, `withCompletion`, `Broadcaster`, `UndoStack` and
  `RequestBuilder`; no base classes, no framework to adopt, no dependencies.
- **Edge cases handled and tested** — overtaken fetches are not cached, a reload keeps the list
  on screen, cancellation is never retried, a slow subscriber cannot grow memory, header values
  with line breaks are refused, numeric link parameters cannot trap on overflow.
- **Swift 6 language mode** — the package builds with strict concurrency checking and no
  warnings; shared state lives in actors or behind a lock.
- **Tested** — 103 Swift Testing tests on macOS and 102 on an iPhone simulator (exit tests run on
  macOS only), including the README samples and the example app's live client against a
  stubbed `URLSession`.
- **Example app** — [PatternGallery](Examples/PatternGallery) for iOS and macOS, with one screen
  per pattern; CI builds it for both platforms.
- **Flutter and React Native ports** — view state, the state machine and undo as a Flutter
  package (11 tests) and a TypeScript package with a React hook (17 tests), in
  [`ports/`](ports).

## Quick start

**1. Add the package**

In Xcode, choose **File › Add Package Dependencies…** and enter the repository URL:

```text
https://github.com/muhittincamdali/mobile-design-patterns.git
```

**2. Import the module**

```swift
import MobilePatterns
```

**3. Use it**

A view model that loads articles through a repository and exposes one view state. A refresh
keeps the current list on screen, and a failed refresh keeps it too:

```swift
@MainActor
@Observable
final class ArticleListModel {
    private(set) var state: Loadable<[Article], ArticleError> = .idle

    private let repository: Repository<String, [Article]>

    init(client: ArticleClient) {
        repository = Repository(capacity: 1, timeToLive: .seconds(300)) { _ in try await client.list() }
    }

    /// Shows cached articles when they are fresh, otherwise loads them.
    func load() async {
        await load(policy: .cacheFirst)
    }

    /// Pull to refresh: keeps the list on screen and replaces it when the new one arrives.
    func refresh() async {
        await load(policy: .reloadIgnoringCache)
    }

    private func load(policy: CachePolicy) async {
        state.startLoading()
        do {
            state.finish(with: .success(try await repository.value(for: "articles", policy: policy)))
        } catch {
            state.finish(with: .failure(error as? ArticleError ?? .offline))
        }
    }
}
```

The view reads `state.value` for the list, `state.isLoading` for the progress indicator and
`state.failure` for the error banner.

## Installation

### Swift Package Manager

In Xcode, choose **File › Add Package Dependencies…** and enter the repository URL:

```text
https://github.com/muhittincamdali/mobile-design-patterns.git
```

Or add it to the `dependencies` in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/mobile-design-patterns.git", from: "2.0.0")
],
targets: [
    .target(name: "YourApp", dependencies: [
        .product(name: "MobilePatterns", package: "mobile-design-patterns")
    ])
]
```

### Flutter and React Native

The ports are not published to pub.dev or npm. Copy `ports/flutter` or `ports/react-native`
into your project, or depend on the folder by path; [ports/README.md](ports/README.md) shows
both.

## Usage

Every sample below is copied from
[`ReadmeSamples.swift`](Examples/PatternGallery/PatternGallery/ReadmeSamples.swift), which the
example app compiles and the package tests run.

### Refuse a second tap with a state machine

The transitions are one `switch`. While the machine is in `.paying`, `.pay` is not allowed, so a
double tap charges once:

```swift
@MainActor
@Observable
final class CheckoutModel {
    private(set) var machine = StateMachine<CheckoutStep, CheckoutEvent>(initial: .cart) { step, event in
        switch (step, event) {
        case (.cart, .pay), (.failed, .retry): .paying
        case (.paying, .succeed): .paid
        case (.paying, .fail): .failed
        default: nil
        }
    }

    private let charge: @Sendable () async throws -> Void

    init(charge: @escaping @Sendable () async throws -> Void) {
        self.charge = charge
    }

    var step: CheckoutStep { machine.state }
    var canPay: Bool { machine.canSend(.pay) || machine.canSend(.retry) }

    /// Charges once. A second tap while paying is refused by the state machine.
    func pay() async {
        guard machine.send(.pay) != nil || machine.send(.retry) != nil else { return }
        do {
            try await charge()
            machine.send(.succeed)
        } catch {
            machine.send(.fail)
        }
    }
}
```

### Open deep links through a router

`DeepLinkParser` checks the scheme, host, credentials, `.` and `..` segments, a `/` or `\` encoded
inside a segment (`%2F`, `%5C`), encoding, control characters and sizes before it matches a
pattern. A pattern returns the whole stack, so the back button works:

```swift
extension DeepLinkParser where Route == AppRoute {
    /// Accepts `https://example.com/…` universal links and `patterns://…` URLs.
    static let app = DeepLinkParser(
        schemes: ["https", "patterns"],
        hosts: ["example.com"],
        patterns: [
            .init("articles") { _ in [.articles] },
            .init("articles/:id") { parameters in
                parameters.int("id").map { [.articles, .article(id: $0)] }
            },
            .init("checkout") { _ in [.checkout] },
            .init("notes") { _ in [.editor] },
            .init("links") { _ in [.links] },
            .init("cart") { _ in [.cart] }
        ]
    )
}

extension Router where Route == AppRoute {
    /// Opens a deep link. Returns `false` and keeps the stack when the link is refused.
    @discardableResult
    func open(_ url: URL) -> Bool {
        guard let routes = try? DeepLinkParser.app.routes(for: url) else { return false }
        return replaceStack(with: routes)
    }
}
```

In the app, `NavigationStack(path: $router.path)` shows the stack and
`.onOpenURL { router.open($0) }` feeds it.

### Add retries, a time limit and request sharing with decorators

`RequestBuilder` encodes the path and query and refuses unsafe headers; `AsyncLoader` adds
behaviour in layers, from the outside in:

```swift
let api = RequestBuilder(baseURL: baseURL).header("Accept", "application/json").timeout(.seconds(15))

// Decorators: a time limit per attempt, two retries for server errors, one shared
// request when several screens ask for the same article.
let article = AsyncLoader<Int, Article> { id in
    try await get(api.path("articles", String(id)), session: session)
}
    .timeout(.seconds(10))
    .retrying(maxAttempts: 3, delay: .milliseconds(300)) { error in
        if case ArticleError.badResponse(let status) = error { return status >= 500 }
        return error is AsyncLoaderTimeoutError
    }
    .coalescing()
```

### Undo edits with commands

```swift
extension EditCommand where Document == Note {
    static func rename(to title: String, from old: String) -> Self {
        .set("Rename", \.title, to: title, from: old)
    }

    static func addTag(_ tag: String) -> Self {
        EditCommand("Add \"\(tag)\"") { $0.tags.append(tag) } revert: { $0.tags.removeLast() }
    }
}

/// Two edits and one undo: the title stays, the tag is gone, and "Rename" is next to undo.
func editedNote() -> UndoStack<Note> {
    var editor = UndoStack(Note(), limit: 20)
    editor.perform(.rename(to: "Weekend trip", from: editor.document.title))
    editor.perform(.addTag("travel"))
    editor.undo()
    return editor
}
```

### Wrap a callback SDK

`withCompletion` keeps the first result and ignores later callbacks, and returns
`CancellationError` as soon as the task is cancelled:

```swift
extension LegacyLocator {
    func currentCity() async throws -> String {
        try await withCompletion { completion in
            locate { city, error in
                if let city { completion(.success(city)) } else { completion(.failure(error ?? ArticleError.offline)) }
            }
        }
    }
}
```

### Send events to several listeners

Each stream from `Broadcaster.events()` gets every later event, with its own bounded buffer:

```swift
@MainActor
@Observable
final class CartBadge {
    private(set) var count = 0

    func listen(to events: AsyncStream<CartEvent>) async {
        for await event in events {
            switch event {
            case .added: count += 1
            case .removed: count = max(0, count - 1)
            }
        }
    }
}
```

Give each listener its own stream (`badge.listen(to: cartEvents.events())`), then call
`cartEvents.send(.added(itemID: 7))` wherever the cart changes.

## Demo

Screens of the example app on an iPhone simulator, captured by
[`scripts/capture-screens.sh`](scripts/capture-screens.sh):

| View state | State machine | Command and undo | Observer | Deep links |
| --- | --- | --- | --- | --- |
| ![View state, light](docs/images/articles-light.png) | ![State machine, light](docs/images/checkout-light.png) | ![Command and undo, light](docs/images/editor-light.png) | ![Observer, light](docs/images/cart-light.png) | ![Deep links, light](docs/images/links-light.png) |
| ![View state, dark](docs/images/articles-dark.png) | ![State machine, dark](docs/images/checkout-dark.png) | ![Command and undo, dark](docs/images/editor-dark.png) | ![Observer, dark](docs/images/cart-dark.png) | ![Deep links, dark](docs/images/links-dark.png) |

To try the patterns yourself, open `PatternGallery.xcodeproj` in
[`Examples/PatternGallery`](Examples/PatternGallery) with Xcode, choose an iPhone simulator or
**My Mac**, and press **Run**. [Examples/README.md](Examples/README.md) also shows how to open a
deep link in the running app.

## Documentation

Reference documentation and articles:

- [API reference](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/)
  (DocC, published to GitHub Pages from `main`)
- Build it locally in Xcode with **Product › Build Documentation**, or from the command line:

```sh
xcodebuild docbuild -scheme MobilePatterns -destination 'generic/platform=macOS'
```

## Guides

- [Getting Started](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/gettingstarted)
  — add the package, replace loading flags with one value, drive navigation from a router
  ([source](Sources/MobilePatterns/MobilePatterns.docc/GettingStarted.md)).
- [Choosing a Pattern](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/choosingapattern)
  — from a symptom in your code to the type that addresses it, and when not to add one
  ([source](Sources/MobilePatterns/MobilePatterns.docc/ChoosingAPattern.md)).
- [Loading Data with View State](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/loadingdatawithviewstate)
  — cache policies per call, drawing every state, cached-then-fresh updates
  ([source](Sources/MobilePatterns/MobilePatterns.docc/LoadingDataWithViewState.md)).
- [Opening Deep Links Safely](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/openingdeeplinkssafely)
  — the parser's checks in order, stacks instead of single screens, errors that do not echo input
  ([source](Sources/MobilePatterns/MobilePatterns.docc/OpeningDeepLinksSafely.md)).
- [Flutter and React Native ports](ports/README.md) — which patterns are ported, and how to run
  their tests.

## Requirements

| Platform | Minimum version |
| --- | --- |
| iOS | 17 |
| macOS | 14 |
| Toolchain | Swift 6.2 · Xcode 26+ |
| Flutter port | Flutter 3.41 · Dart 3.11 |
| React Native port | React 19 · Node 22.22 for the tests |

## Architecture

```text
Sources/MobilePatterns/
├── State/         Loadable, StateMachine
├── Navigation/    Router, DeepLinkParser
├── Data/          Repository, CachePolicy, AsyncLoader
├── Concurrency/   withCompletion, Broadcaster
├── Editing/       UndoStack, EditCommand
└── Networking/    RequestBuilder
Examples/PatternGallery/   iOS and macOS app; ReadmeSamples.swift is shared with the tests
ports/flutter/             Loadable, LoadableController, LoadableView, StateMachine, UndoStack
ports/react-native/        Loadable, useLoadable, StateMachine, UndoStack
```

Design decisions:

- **Value types where the state is local** (`Loadable`, `StateMachine`, `UndoStack`,
  `RequestBuilder`), an **actor** where callers share state (`Repository`), and a lock where a
  synchronous API is needed from any thread (`Broadcaster`, `withCompletion`).
- **Bounded by default.** Router depth, repository capacity, undo history, broadcaster buffers
  and deep-link sizes all have limits; values below the minimum are raised to it instead of
  trapping.
- **Input from outside is checked before use.** Deep links and request parts are validated, and
  errors carry no copy of the rejected input.
- **The README cannot drift.** Its samples live in a Swift file that the example app builds and
  the tests run.

## Roadmap

- Add the package to the Swift Package Index after the 2.0.0 release; `.spi.yml` is already in
  the repository.
- Port `DeepLinkParser` to Dart and TypeScript, where the same checks apply to `go_router` and
  React Navigation links.
- A debouncer for search fields, with a test clock.

## Contributing

Contributions are welcome. Read the [contributing guide](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/CONTRIBUTING.md) and the [code of conduct](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/CODE_OF_CONDUCT.md) before opening a pull request. Report security issues privately as described in the [security policy](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/SECURITY.md).

## License

Released under the MIT license. See [LICENSE](LICENSE).
