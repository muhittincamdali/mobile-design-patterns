<!-- i18n-source: README.md@71ad011be475bbe9b9383401e2ebea4ec421dc04 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-light.svg" alt="Mobile Design Patterns: Design patterns for iOS and macOS apps as tested Swift types, with Flutter and React Native ports."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/mobile-design-patterns/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/mobile-design-patterns/actions/workflows/ci.yml/badge.svg" alt="CI 상태"></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-light.svg" alt="최신 버전: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-light.svg" alt="지원 플랫폼: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-light.svg" alt="언어 버전: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-light.svg" alt="라이선스: MIT"></picture></a>
</p>

<p align="center">
<a href="#빠른-시작"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-ko-light.svg" alt="시작하기"></picture></a>
<a href="https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-ko-light.svg" alt="문서"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-ko-light.svg" alt="예제"></picture></a>
</p>

> 이 문서는 영어 README의 번역본입니다. 내용이 다를 경우 영어 버전이 최신입니다.

<!-- brand:end -->

iOS와 macOS 앱을 위한 디자인 패턴을 하나씩 따로 쓸 수 있는 작은 타입으로 구현한 Swift 패키지입니다. 뷰 상태, 상태 머신, coordinator와 deep link, repository, decorator, adapter, observer, 실행 취소를 지원하는 command, builder를 담고 있습니다. 패턴 이름은 알고 있고, 실제 앱에서 버티는 구현을 원하는 앱 개발자를 위한 패키지입니다. 결제가 진행되는 동안 두 번째 탭을 거부하고, completion handler가 두 번 호출되어도 문제가 없으며, 경로에 `..`가 들어 있는 deep link는 받아들이지 않습니다. 모든 패턴에는 테스트가 있고, README의 예제는 테스트로 컴파일되어 실행되며, 예제 앱이 각 패턴을 화면에서 보여 줍니다. 뷰 상태, 상태 머신, 실행 취소는 Flutter와 React Native 패키지로도 제공됩니다.

## 주요 기능

- **패턴마다 타입 하나** — `Loadable`, `StateMachine`, `Router`, `DeepLinkParser`,
  `Repository`, `AsyncLoader`, `withCompletion`, `Broadcaster`, `UndoStack`,
  `RequestBuilder`. 기반 클래스도, 도입해야 할 프레임워크도, 의존성도 없습니다.
- **엣지 케이스를 처리하고 테스트함** — 더 나중에 시작된 요청에 추월당한 fetch 결과는 캐시하지 않고, 다시 불러오는 동안에도 목록은 화면에 남아 있으며, 취소된 작업은 다시 시도하지 않고, 느린 구독자가 메모리를 늘릴 수 없으며, 줄바꿈이 들어간 헤더 값은 거부하고, 숫자 링크 매개변수는 오버플로가 나도 크래시하지 않습니다.
- **Swift 6 언어 모드** — 패키지는 엄격한 동시성 검사 아래에서 경고 없이 빌드됩니다. 공유 상태는 actor 안에 있거나 락 뒤에 있습니다.
- **테스트됨** — macOS에서 Swift Testing 테스트 103개, iPhone 시뮬레이터에서 102개를 실행합니다(exit test는 macOS에서만 실행됩니다). README 예제와, 스텁으로 대체한 `URLSession`을 상대로 하는 예제 앱의 실제 클라이언트 테스트도 포함됩니다.
- **예제 앱** — iOS와 macOS용 [PatternGallery](Examples/PatternGallery)에 패턴마다 화면이 하나씩 있으며, CI가 두 플랫폼 모두에서 빌드합니다.
- **Flutter와 React Native 포트** — 뷰 상태, 상태 머신, 실행 취소를 Flutter 패키지(테스트 11개)와 React hook이 포함된 TypeScript 패키지(테스트 17개)로 [`ports/`](ports)에 제공합니다.

## 빠른 시작

**1. 패키지 추가**

Xcode에서 **File › Add Package Dependencies…**를 선택하고 저장소 URL을 입력하세요.

```text
https://github.com/muhittincamdali/mobile-design-patterns.git
```

**2. 모듈 가져오기**

```swift
import MobilePatterns
```

**3. 사용하기**

repository를 통해 기사를 불러오고 하나의 뷰 상태를 노출하는 view model입니다. 새로고침하는 동안에도 현재 목록은 화면에 남아 있고, 새로고침이 실패해도 그대로 남아 있습니다.

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

뷰는 목록을 `state.value`에서, 진행 표시기를 `state.isLoading`에서, 오류 배너를 `state.failure`에서 읽습니다.

## 설치

### Swift Package Manager

Xcode에서 **File › Add Package Dependencies…**를 선택하고 저장소 URL을 입력하세요.

```text
https://github.com/muhittincamdali/mobile-design-patterns.git
```

또는 `Package.swift`의 `dependencies`에 추가하세요.

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

### Flutter와 React Native

포트는 pub.dev나 npm에 게시하지 않았습니다. `ports/flutter` 또는 `ports/react-native`를 프로젝트에 복사하거나, 폴더를 경로로 지정해 의존하세요. 두 방법 모두 [ports/README.md](ports/README.md)에 나와 있습니다.

## 사용법

아래 예제는 모두 [`ReadmeSamples.swift`](Examples/PatternGallery/PatternGallery/ReadmeSamples.swift)에서 가져온 것입니다. 이 파일은 예제 앱이 컴파일하고 패키지 테스트가 실행합니다.

### 상태 머신으로 두 번째 탭 거부하기

전환은 하나의 `switch`입니다. 머신이 `.paying` 상태일 때는 `.pay`가 허용되지 않으므로, 더블 탭을 해도 결제는 한 번만 이루어집니다.

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

### router로 deep link 열기

`DeepLinkParser`는 패턴과 대조하기 전에 scheme, host, 자격 증명, `.`와 `..` 세그먼트, 세그먼트 안에 인코딩된 `/`나 `\`(`%2F`, `%5C`), 인코딩, 제어 문자, 크기를 검사합니다. 패턴은 스택 전체를 반환하므로 뒤로 가기 버튼이 제대로 동작합니다.

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

앱에서는 `NavigationStack(path: $router.path)`가 스택을 보여 주고, `.onOpenURL { router.open($0) }`가 스택에 값을 전달합니다.

### decorator로 재시도, 시간 제한, 요청 공유 추가하기

`RequestBuilder`는 경로와 쿼리를 인코딩하고 안전하지 않은 헤더를 거부합니다. `AsyncLoader`는 바깥쪽에서 안쪽으로 동작을 층층이 더합니다.

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

### command로 편집 실행 취소하기

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

### 콜백 기반 SDK 감싸기

`withCompletion`은 첫 번째 결과를 유지하고 이후의 콜백은 무시하며, 작업이 취소되는 즉시 `CancellationError`를 반환합니다.

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

### 여러 리스너에 이벤트 보내기

`Broadcaster.events()`가 반환하는 각 스트림은 이후의 모든 이벤트를 받으며, 스트림마다 크기가 제한된 자체 버퍼를 가집니다.

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

리스너마다 자기 스트림을 주고(`badge.listen(to: cartEvents.events())`), 장바구니가 바뀌는 곳마다 `cartEvents.send(.added(itemID: 7))`를 호출하세요.

## 데모

iPhone 시뮬레이터에서 본 예제 앱 화면이며, [`scripts/capture-screens.sh`](scripts/capture-screens.sh)로 캡처했습니다.

| 뷰 상태 | 상태 머신 | Command와 실행 취소 | Observer | Deep link |
| --- | --- | --- | --- | --- |
| ![뷰 상태, 라이트](docs/images/articles-light.png) | ![상태 머신, 라이트](docs/images/checkout-light.png) | ![Command와 실행 취소, 라이트](docs/images/editor-light.png) | ![Observer, 라이트](docs/images/cart-light.png) | ![Deep link, 라이트](docs/images/links-light.png) |
| ![뷰 상태, 다크](docs/images/articles-dark.png) | ![상태 머신, 다크](docs/images/checkout-dark.png) | ![Command와 실행 취소, 다크](docs/images/editor-dark.png) | ![Observer, 다크](docs/images/cart-dark.png) | ![Deep link, 다크](docs/images/links-dark.png) |

패턴을 직접 사용해 보려면 [`Examples/PatternGallery`](Examples/PatternGallery)의 `PatternGallery.xcodeproj`를 Xcode로 열고, iPhone 시뮬레이터나 **My Mac**을 선택한 다음 **Run**을 누르세요. 실행 중인 앱에서 deep link를 여는 방법도 [Examples/README.md](Examples/README.md)에 나와 있습니다.

## 문서

API 레퍼런스와 문서:

- [API 레퍼런스](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/)
  (DocC, `main`에서 GitHub Pages로 게시)
- Xcode에서는 **Product › Build Documentation**으로, 명령줄에서는 다음 명령으로 로컬에서 빌드할 수 있습니다.

```sh
xcodebuild docbuild -scheme MobilePatterns -destination 'generic/platform=macOS'
```

## 가이드

- [Getting Started](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/gettingstarted)
  — 패키지를 추가하고, 로딩 플래그를 하나의 값으로 바꾸고, router로 내비게이션을 구동하는 방법
  ([소스](Sources/MobilePatterns/MobilePatterns.docc/GettingStarted.md)).
- [Choosing a Pattern](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/choosingapattern)
  — 코드에서 보이는 증상에서 이를 해결하는 타입으로 가는 길, 그리고 추가하지 말아야 할 때
  ([소스](Sources/MobilePatterns/MobilePatterns.docc/ChoosingAPattern.md)).
- [Loading Data with View State](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/loadingdatawithviewstate)
  — 호출별 캐시 정책, 모든 상태 그리기, 캐시를 먼저 보여 주고 최신 데이터로 갱신하기
  ([소스](Sources/MobilePatterns/MobilePatterns.docc/LoadingDataWithViewState.md)).
- [Opening Deep Links Safely](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/openingdeeplinkssafely)
  — 파서가 순서대로 수행하는 검사, 단일 화면 대신 스택 사용, 입력을 그대로 돌려주지 않는 오류
  ([소스](Sources/MobilePatterns/MobilePatterns.docc/OpeningDeepLinksSafely.md)).
- [Flutter와 React Native 포트](ports/README.md) — 어떤 패턴이 포팅되었는지, 그리고 테스트를 실행하는 방법.

## 요구 사항

| 플랫폼 | 최소 버전 |
| --- | --- |
| iOS | 17 |
| macOS | 14 |
| 툴체인 | Swift 6.2 · Xcode 26+ |
| Flutter 포트 | Flutter 3.41 · Dart 3.11 |
| React Native 포트 | React 19 · 테스트용 Node 22.22 |

## 아키텍처

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

설계 결정:

- **상태가 로컬인 곳에는 값 타입**(`Loadable`, `StateMachine`, `UndoStack`, `RequestBuilder`), 호출자들이 상태를 공유하는 곳에는 **actor**(`Repository`), 어떤 스레드에서든 동기 API가 필요한 곳에는 락(`Broadcaster`, `withCompletion`)을 사용합니다.
- **기본적으로 상한이 있습니다.** router 깊이, repository 용량, 실행 취소 기록, broadcaster 버퍼, deep link 크기에는 모두 한도가 있으며, 최솟값보다 작은 값은 크래시하는 대신 최솟값으로 올려 줍니다.
- **외부 입력은 사용하기 전에 검사합니다.** deep link와 요청의 각 부분은 검증되며, 오류에는 거부된 입력의 사본이 담기지 않습니다.
- **README가 코드와 어긋나지 않습니다.** 예제는 예제 앱이 빌드하고 테스트가 실행하는 Swift 파일에 있습니다.

## 로드맵

- 2.0.0 릴리스 후 패키지를 Swift Package Index에 추가할 예정입니다. `.spi.yml`은 이미 저장소에 있습니다.
- `DeepLinkParser`를 Dart와 TypeScript로 포팅할 예정입니다. 같은 검사는 `go_router`와 React Navigation 링크에도 적용됩니다.
- 테스트용 시계를 갖춘 검색 필드용 debouncer를 추가할 예정입니다.

## 기여하기

기여를 환영합니다. pull request를 열기 전에 [기여 가이드](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/CONTRIBUTING.md)와 [행동 강령](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/CODE_OF_CONDUCT.md)을 읽어 주세요. 보안 문제는 [보안 정책](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/SECURITY.md)에 따라 비공개로 제보해 주세요.

## 라이선스

MIT 라이선스로 배포됩니다. 자세한 내용은 [LICENSE](LICENSE)를 참고하세요.
