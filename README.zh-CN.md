<!-- i18n-source: README.md@16017df9aef14bbde7c1c89e6d452012f4124845 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-light.svg" alt="Mobile Design Patterns: Design patterns for iOS and macOS apps as tested Swift types, with Flutter and React Native ports."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/mobile-design-patterns/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/mobile-design-patterns/actions/workflows/ci.yml/badge.svg" alt="CI 状态"></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-light.svg" alt="最新版本: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-light.svg" alt="支持的平台: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-light.svg" alt="语言版本: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-light.svg" alt="许可证: MIT"></picture></a>
</p>

<p align="center">
<a href="#快速开始"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-zh-CN-light.svg" alt="开始使用"></picture></a>
<a href="https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-zh-CN-light.svg" alt="文档"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-zh-CN-light.svg" alt="示例"></picture></a>
</p>

> 本文是英文 README 的译文。如两者内容不一致，以英文版为准。

<!-- brand:end -->

这是一个面向 iOS 和 macOS 应用的 Swift 设计模式包，每种模式都写成可以单独使用的小型类型：视图状态、状态机、coordinator 与 deep link、repository、decorator、adapter、observer、带撤销的 command，以及 builder。它面向已经熟悉这些模式名称、希望得到一个能在真实应用中站得住脚的版本的开发者：支付进行时拒绝第二次点击，能应对被调用两次的 completion handler，并拒绝路径中带有 `..` 的 deep link。每种模式都有测试，README 中的示例会作为测试编译并运行，示例应用在屏幕上演示每一种模式。视图状态、状态机和撤销还提供 Flutter 和 React Native 版本的包。

## 亮点

- **每种模式一个类型** — `Loadable`、`StateMachine`、`Router`、`DeepLinkParser`、
  `Repository`、`AsyncLoader`、`withCompletion`、`Broadcaster`、`UndoStack` 和
  `RequestBuilder`；没有基类，无需采用任何框架，没有依赖。
- **边界情况均已处理并有测试** — 被后发请求超过的获取结果不会写入缓存，重新加载时列表仍留在屏幕上，已取消的操作绝不重试，缓慢的订阅者不会让内存持续增长，含换行符的 header 值会被拒绝，数值型链接参数在溢出时不会崩溃。
- **Swift 6 语言模式** — 该包在严格的并发检查下构建，没有警告；共享状态放在 actor 中或由锁保护。
- **经过测试** — macOS 上有 96 个 Swift Testing 测试，iPhone 模拟器上有 95 个（exit test 仅在 macOS 上运行），其中包括 README 示例，以及示例应用的真实客户端针对 stub 化的 `URLSession` 的测试。
- **示例应用** — 面向 iOS 和 macOS 的 [PatternGallery](Examples/PatternGallery)，每种模式一个页面；CI 会在两个平台上构建它。
- **Flutter 和 React Native 移植版** — 视图状态、状态机和撤销，提供一个 Flutter 包（11 个测试）和一个带 React hook 的 TypeScript 包（17 个测试），位于 [`ports/`](ports)。

## 快速开始

**1. 添加软件包**

在 Xcode 中选择 **File › Add Package Dependencies…**，然后输入仓库地址：

```text
https://github.com/muhittincamdali/mobile-design-patterns.git
```

**2. 导入模块**

```swift
import MobilePatterns
```

**3. 开始使用**

一个通过 repository 加载文章并暴露单一视图状态的 view model。刷新时当前列表仍留在屏幕上，刷新失败时同样如此：

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

视图通过 `state.value` 读取列表，通过 `state.isLoading` 读取进度指示器的状态，通过 `state.failure` 读取错误横幅的内容。

## 安装

### Swift Package Manager

在 Xcode 中选择 **File › Add Package Dependencies…**，然后输入仓库地址：

```text
https://github.com/muhittincamdali/mobile-design-patterns.git
```

或者将其添加到 `Package.swift` 的 `dependencies` 中：

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

### Flutter 和 React Native

这些移植版没有发布到 pub.dev 或 npm。请把 `ports/flutter` 或 `ports/react-native` 复制到你的项目中，或者按路径依赖该文件夹；两种方式都写在 [ports/README.md](ports/README.md) 中。

## 使用方法

下面的每个示例都复制自 [`ReadmeSamples.swift`](Examples/PatternGallery/PatternGallery/ReadmeSamples.swift)，示例应用会编译它，包测试会运行它。

### 用状态机拒绝第二次点击

状态转换就是一个 `switch`。机器处于 `.paying` 时不允许 `.pay`，因此连点两次也只会扣款一次：

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

### 通过 router 打开 deep link

`DeepLinkParser` 会先检查 scheme、host、凭据、`.` 和 `..` 路径段、编码、控制字符和大小，然后才去匹配某个模式。模式返回整个导航栈，所以返回按钮可以正常工作：

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

在应用中，`NavigationStack(path: $router.path)` 显示导航栈，`.onOpenURL { router.open($0) }` 为它提供数据。

### 用 decorator 添加重试、时间限制和请求共享

`RequestBuilder` 会对路径和查询进行编码，并拒绝不安全的 header；`AsyncLoader` 由外向内逐层添加行为：

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

### 用 command 撤销编辑

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

### 封装基于回调的 SDK

`withCompletion` 保留第一个结果并忽略之后的回调，任务一被取消就返回 `CancellationError`：

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

### 向多个监听者发送事件

`Broadcaster.events()` 返回的每个流都会收到之后的所有事件，并拥有各自有界的缓冲区：

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

给每个监听者一个独立的流（`badge.listen(to: cartEvents.events())`），然后在购物车发生变化的任何地方调用 `cartEvents.send(.added(itemID: 7))`。

## 演示

示例应用在 iPhone 模拟器上的界面，由 [`scripts/capture-screens.sh`](scripts/capture-screens.sh) 截取：

| 视图状态 | 状态机 | Command 与撤销 | Observer | Deep link |
| --- | --- | --- | --- | --- |
| ![视图状态，浅色](docs/images/articles-light.png) | ![状态机，浅色](docs/images/checkout-light.png) | ![Command 与撤销，浅色](docs/images/editor-light.png) | ![Observer，浅色](docs/images/cart-light.png) | ![Deep link，浅色](docs/images/links-light.png) |
| ![视图状态，深色](docs/images/articles-dark.png) | ![状态机，深色](docs/images/checkout-dark.png) | ![Command 与撤销，深色](docs/images/editor-dark.png) | ![Observer，深色](docs/images/cart-dark.png) | ![Deep link，深色](docs/images/links-dark.png) |

想亲自体验这些模式，请用 Xcode 打开 [`Examples/PatternGallery`](Examples/PatternGallery) 中的 `PatternGallery.xcodeproj`，选择一个 iPhone 模拟器或 **My Mac**，然后点击 **Run**。[Examples/README.md](Examples/README.md) 还介绍了如何在运行中的应用里打开 deep link。

## 文档

API 参考文档与文章：

- [API 参考](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/)
  （DocC，从 `main` 分支发布到 GitHub Pages）
- 在 Xcode 中通过 **Product › Build Documentation** 在本地构建，或使用命令行：

```sh
xcodebuild docbuild -scheme MobilePatterns -destination 'generic/platform=macOS'
```

## 指南

- [Getting Started](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/gettingstarted)
  — 添加该包，用一个值取代各种加载标志，由 router 驱动导航
  （[源文件](Sources/MobilePatterns/MobilePatterns.docc/GettingStarted.md)）。
- [Choosing a Pattern](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/choosingapattern)
  — 从代码中的症状找到对应的类型，以及何时不该添加
  （[源文件](Sources/MobilePatterns/MobilePatterns.docc/ChoosingAPattern.md)）。
- [Loading Data with View State](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/loadingdatawithviewstate)
  — 按调用设置缓存策略，绘制每一种状态，先显示缓存再更新为最新数据
  （[源文件](Sources/MobilePatterns/MobilePatterns.docc/LoadingDataWithViewState.md)）。
- [Opening Deep Links Safely](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/openingdeeplinkssafely)
  — 解析器按顺序执行的检查，用导航栈代替单个页面，不回显输入内容的错误
  （[源文件](Sources/MobilePatterns/MobilePatterns.docc/OpeningDeepLinksSafely.md)）。
- [Flutter 和 React Native 移植版](ports/README.md) — 移植了哪些模式，以及如何运行它们的测试。

## 系统要求

| 平台 | 最低版本 |
| --- | --- |
| iOS | 17 |
| macOS | 14 |
| 工具链 | Swift 6.2 · Xcode 26+ |
| Flutter 移植版 | Flutter 3.41 · Dart 3.11 |
| React Native 移植版 | React 19 · 运行测试需要 Node 22.22 |

## 架构

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

设计决策：

- **状态为局部时使用值类型**（`Loadable`、`StateMachine`、`UndoStack`、`RequestBuilder`），调用方共享状态时使用 **actor**（`Repository`），需要在任意线程上同步调用 API 时使用锁（`Broadcaster`、`withCompletion`）。
- **默认有界。** Router 的深度、repository 的容量、撤销历史、broadcaster 的缓冲区和 deep link 的大小都有上限；低于下限的值会被提升到下限，而不是崩溃。
- **来自外部的输入先检查再使用。** Deep link 和请求的各个部分都会被校验，错误中不会带有被拒绝输入的副本。
- **README 不会过时。** 其中的示例位于一个 Swift 文件中，由示例应用构建，并由测试运行。

## 路线图

- 2.0.0 发布后，把该包提交到 Swift Package Index；`.spi.yml` 已在仓库中。
- 把 `DeepLinkParser` 移植到 Dart 和 TypeScript，相同的检查同样适用于 `go_router` 和 React Navigation 的链接。
- 为搜索框提供带测试时钟的 debouncer。

## 参与贡献

欢迎参与贡献。提交 pull request 之前，请先阅读[贡献指南](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/CONTRIBUTING.md)和[行为准则](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/CODE_OF_CONDUCT.md)。如发现安全问题，请按照[安全策略](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/SECURITY.md)私下报告。

## 许可证

基于 MIT 许可证发布。详见 [LICENSE](LICENSE)。
