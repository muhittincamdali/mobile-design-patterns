<!-- i18n-source: README.md@7e585ab27e1814cb9809e32b683be9fa941ed2ec status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-light.svg" alt="Mobile Design Patterns: Design patterns for iOS and macOS apps as tested Swift types, with Flutter and React Native ports."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/mobile-design-patterns/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/mobile-design-patterns/actions/workflows/ci.yml/badge.svg" alt="CI ステータス"></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-light.svg" alt="最新バージョン: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-light.svg" alt="対応プラットフォーム: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-light.svg" alt="言語バージョン: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-light.svg" alt="ライセンス: MIT"></picture></a>
</p>

<p align="center">
<a href="#クイックスタート"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-ja-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-ja-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-ja-light.svg" alt="はじめる"></picture></a>
<a href="https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-ja-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-ja-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-ja-light.svg" alt="ドキュメント"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-ja-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-ja-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-ja-light.svg" alt="サンプル"></picture></a>
</p>

> このドキュメントは英語版 README の翻訳です。内容が異なる場合は英語版が最新です。

<!-- brand:end -->

iOS と macOS アプリ向けのデザインパターンを、1 つずつ使える小さな型として書いた Swift パッケージです。ビュー状態、ステートマシン、coordinator と deep link、repository、decorator、adapter、observer、取り消し付きの command、builder を収録しています。パターン名は知っていて、実際のアプリで通用する実装がほしい開発者向けです。決済の実行中は 2 回目のタップを受け付けず、completion handler が 2 回呼ばれても壊れず、パスに `..` を含む deep link を拒否します。すべてのパターンにテストがあり、README のサンプルはテストとしてコンパイル・実行され、サンプルアプリが各パターンを画面で確認できます。ビュー状態、ステートマシン、取り消しは Flutter と React Native のパッケージとしても提供しています。

## 主な特長

- **パターンごとに 1 つの型** — `Loadable`、`StateMachine`、`Router`、`DeepLinkParser`、
  `Repository`、`AsyncLoader`、`withCompletion`、`Broadcaster`、`UndoStack`、
  `RequestBuilder`。基底クラスも、導入すべきフレームワークも、依存関係もありません。
- **エッジケースを処理し、テスト済み** — 後発のリクエストに追い越された取得結果はキャッシュされません。再読み込み中も一覧は画面に残ります。キャンセルは再試行されません。遅い購読者がメモリを増やすことはありません。改行を含むヘッダー値は拒否されます。数値のリンクパラメーターはオーバーフローしてもクラッシュしません。
- **Swift 6 言語モード** — パッケージは厳格な並行処理チェックのもとで、警告なしにビルドされます。共有状態は actor の中か、ロックの背後に置かれています。
- **テスト済み** — macOS で 100 件、iPhone シミュレータで 99 件の Swift Testing テストがあります（exit test は macOS でのみ実行されます）。README のサンプルや、サンプルアプリの実クライアントをスタブ化した `URLSession` に対して動かすテストも含みます。
- **サンプルアプリ** — iOS と macOS 向けの [PatternGallery](Examples/PatternGallery)。パターンごとに 1 画面あり、CI が両方のプラットフォームでビルドします。
- **Flutter と React Native への移植** — ビュー状態、ステートマシン、取り消しを、Flutter パッケージ（テスト 11 件）と React フックを備えた TypeScript パッケージ（テスト 17 件）として [`ports/`](ports) に用意しています。

## クイックスタート

**1. パッケージを追加する**

Xcode で **File › Add Package Dependencies…** を選び、リポジトリの URL を入力します。

```text
https://github.com/muhittincamdali/mobile-design-patterns.git
```

**2. モジュールをインポートする**

```swift
import MobilePatterns
```

**3. 使ってみる**

repository を通して記事を読み込み、1 つのビュー状態を公開する view model です。更新中も現在の一覧は画面に残り、更新に失敗した場合も残ります。

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

ビューは、一覧を `state.value` から、プログレスインジケーターを `state.isLoading` から、エラーバナーを `state.failure` から読み取ります。

## インストール

### Swift Package Manager

Xcode で **File › Add Package Dependencies…** を選び、リポジトリの URL を入力します。

```text
https://github.com/muhittincamdali/mobile-design-patterns.git
```

または `Package.swift` の `dependencies` に追加します。

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

### Flutter と React Native

移植版は pub.dev にも npm にも公開していません。`ports/flutter` または `ports/react-native` をプロジェクトにコピーするか、フォルダーをパスで指定して依存してください。どちらの方法も [ports/README.md](ports/README.md) に載っています。

## 使い方

以下のサンプルはすべて [`ReadmeSamples.swift`](Examples/PatternGallery/PatternGallery/ReadmeSamples.swift) からコピーしたものです。このファイルはサンプルアプリがコンパイルし、パッケージのテストが実行します。

### ステートマシンで 2 回目のタップを拒否する

遷移は 1 つの `switch` です。マシンが `.paying` の間は `.pay` が許可されないため、ダブルタップしても課金は 1 回だけです。

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

### router で deep link を開く

`DeepLinkParser` は、パターンと照合する前に、scheme、host、認証情報、`.` と `..` のセグメント、エンコード、制御文字、サイズを検査します。パターンはスタック全体を返すので、戻るボタンが正しく動きます。

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

アプリでは、`NavigationStack(path: $router.path)` がスタックを表示し、`.onOpenURL { router.open($0) }` がそこに値を渡します。

### decorator でリトライ、時間制限、リクエスト共有を加える

`RequestBuilder` はパスとクエリをエンコードし、安全でないヘッダーを拒否します。`AsyncLoader` は外側から内側へ、層にして動作を加えます。

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

### command で編集を取り消す

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

### コールバック型の SDK をラップする

`withCompletion` は最初の結果を保持して以降のコールバックを無視し、タスクがキャンセルされると直ちに `CancellationError` を返します。

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

### 複数のリスナーにイベントを送る

`Broadcaster.events()` が返すストリームは、それぞれ以降のすべてのイベントを受け取り、独自の上限付きバッファーを持ちます。

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

リスナーごとに専用のストリームを渡し（`badge.listen(to: cartEvents.events())`）、カートが変わる場所で `cartEvents.send(.added(itemID: 7))` を呼びます。

## デモ

iPhone シミュレータ上のサンプルアプリの画面です。[`scripts/capture-screens.sh`](scripts/capture-screens.sh) で撮影しました。

| ビュー状態 | ステートマシン | Command と取り消し | Observer | Deep link |
| --- | --- | --- | --- | --- |
| ![ビュー状態（ライト）](docs/images/articles-light.png) | ![ステートマシン（ライト）](docs/images/checkout-light.png) | ![Command と取り消し（ライト）](docs/images/editor-light.png) | ![Observer（ライト）](docs/images/cart-light.png) | ![Deep link（ライト）](docs/images/links-light.png) |
| ![ビュー状態（ダーク）](docs/images/articles-dark.png) | ![ステートマシン（ダーク）](docs/images/checkout-dark.png) | ![Command と取り消し（ダーク）](docs/images/editor-dark.png) | ![Observer（ダーク）](docs/images/cart-dark.png) | ![Deep link（ダーク）](docs/images/links-dark.png) |

パターンを自分で試すには、[`Examples/PatternGallery`](Examples/PatternGallery) の `PatternGallery.xcodeproj` を Xcode で開き、iPhone シミュレータまたは **My Mac** を選んで **Run** を押します。実行中のアプリで deep link を開く方法は [Examples/README.md](Examples/README.md) にも載っています。

## ドキュメント

API リファレンスと解説記事：

- [API リファレンス](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/)
  （DocC。`main` から GitHub Pages に公開）
- Xcode では **Product › Build Documentation** で、コマンドラインでは次のようにして、ローカルでビルドできます。

```sh
xcodebuild docbuild -scheme MobilePatterns -destination 'generic/platform=macOS'
```

## ガイド

- [Getting Started](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/gettingstarted)
  — パッケージの追加、読み込みフラグを 1 つの値に置き換える方法、router によるナビゲーションの制御
  （[ソース](Sources/MobilePatterns/MobilePatterns.docc/GettingStarted.md)）。
- [Choosing a Pattern](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/choosingapattern)
  — コード上の症状から、それに対処する型を選ぶ方法と、追加すべきでないとき
  （[ソース](Sources/MobilePatterns/MobilePatterns.docc/ChoosingAPattern.md)）。
- [Loading Data with View State](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/loadingdatawithviewstate)
  — 呼び出しごとのキャッシュポリシー、すべての状態の描画、キャッシュを先に見せてから最新に更新する方法
  （[ソース](Sources/MobilePatterns/MobilePatterns.docc/LoadingDataWithViewState.md)）。
- [Opening Deep Links Safely](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/openingdeeplinkssafely)
  — パーサーが行う検査の順序、単一画面ではなくスタックを使う理由、入力をそのまま返さないエラー
  （[ソース](Sources/MobilePatterns/MobilePatterns.docc/OpeningDeepLinksSafely.md)）。
- [Flutter と React Native への移植](ports/README.md) — 移植済みのパターンと、そのテストの実行方法。

## 動作要件

| プラットフォーム | 最小バージョン |
| --- | --- |
| iOS | 17 |
| macOS | 14 |
| ツールチェーン | Swift 6.2 · Xcode 26+ |
| Flutter 移植版 | Flutter 3.41 · Dart 3.11 |
| React Native 移植版 | React 19 · テストには Node 22.22 |

## アーキテクチャ

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

設計上の判断：

- **状態がローカルな場合は値型**（`Loadable`、`StateMachine`、`UndoStack`、`RequestBuilder`）、呼び出し側が状態を共有する場合は **actor**（`Repository`）、任意のスレッドから同期 API が必要な場合はロック（`Broadcaster`、`withCompletion`）を使います。
- **既定で上限あり。** router の深さ、repository の容量、取り消し履歴、broadcaster のバッファー、deep link のサイズにはすべて上限があります。下限を下回る値は、クラッシュさせずに下限まで引き上げられます。
- **外部からの入力は使う前に検査する。** deep link とリクエストの各部分は検証され、エラーには拒否した入力のコピーが含まれません。
- **README がコードとずれない。** サンプルは Swift ファイルにあり、サンプルアプリがビルドし、テストが実行します。

## ロードマップ

- 2.0.0 のリリース後、パッケージを Swift Package Index に追加します。`.spi.yml` はすでにリポジトリにあります。
- `DeepLinkParser` を Dart と TypeScript に移植します。同じ検査は `go_router` や React Navigation のリンクにも当てはまります。
- 検索フィールド向けの debouncer を、テスト用のクロック付きで追加します。

## コントリビューション

コントリビューションを歓迎します。pull request を作成する前に[コントリビューションガイド](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/CONTRIBUTING.md)と[行動規範](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/CODE_OF_CONDUCT.md)をお読みください。セキュリティ上の問題は[セキュリティポリシー](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/SECURITY.md)に従って非公開で報告してください。

## ライセンス

MIT ライセンスで公開しています。詳細は [LICENSE](LICENSE) を参照してください。
