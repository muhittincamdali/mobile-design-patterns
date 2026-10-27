<!-- i18n-source: README.md@16017df9aef14bbde7c1c89e6d452012f4124845 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-light.svg" alt="Mobile Design Patterns: Design patterns for iOS and macOS apps as tested Swift types, with Flutter and React Native ports."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/mobile-design-patterns/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/mobile-design-patterns/actions/workflows/ci.yml/badge.svg" alt="Статус CI"></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-light.svg" alt="Последняя версия: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-light.svg" alt="Поддерживаемые платформы: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-light.svg" alt="Версия языка: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-light.svg" alt="Лицензия: MIT"></picture></a>
</p>

<p align="center">
<a href="#быстрый-старт"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-ru-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-ru-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-ru-light.svg" alt="Начать"></picture></a>
<a href="https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-ru-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-ru-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-ru-light.svg" alt="Документация"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-ru-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-ru-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-ru-light.svg" alt="Примеры"></picture></a>
</p>

> Это перевод README на английском языке. Если они расходятся, актуальна английская версия.

<!-- brand:end -->

Swift-пакет с паттернами проектирования для приложений iOS и macOS, оформленными как небольшие типы, которые можно использовать по одному: состояние представления, конечный автомат, coordinator и deep link, repository, decorator, adapter, observer, command с отменой действий и builder. Он рассчитан на разработчиков приложений, которые знают названия паттернов и хотят получить версию, выдерживающую реальное приложение: такую, что отклоняет второе нажатие, пока идёт платёж, переживает дважды вызванный completion handler и отвергает deep link с `..` в пути. У каждого паттерна есть тесты, примеры из README компилируются и запускаются как тесты, а демонстрационное приложение показывает каждый паттерн на экране. Состояние представления, конечный автомат и отмена действий также доступны в виде пакетов для Flutter и React Native.

## Основные возможности

- **По одному типу на паттерн** — `Loadable`, `StateMachine`, `Router`, `DeepLinkParser`,
  `Repository`, `AsyncLoader`, `withCompletion`, `Broadcaster`, `UndoStack` и
  `RequestBuilder`; никаких базовых классов, никакого фреймворка, который нужно принимать целиком, и никаких зависимостей.
- **Граничные случаи учтены и покрыты тестами** — результаты запросов, которых обогнал более новый запрос, не кешируются, при перезагрузке список остаётся на экране, отменённая операция никогда не повторяется, медленный подписчик не может раздуть память, значения заголовков с переводами строк отклоняются, а числовые параметры ссылок не приводят к аварийному завершению при переполнении.
- **Языковой режим Swift 6** — пакет собирается со строгой проверкой конкурентности и без предупреждений; общее состояние находится в actor или за блокировкой.
- **Протестировано** — 96 тестов Swift Testing на macOS и 95 на симуляторе iPhone (exit-тесты запускаются только на macOS), включая примеры из README и настоящий клиент демонстрационного приложения, работающий с подменённым через stub `URLSession`.
- **Демонстрационное приложение** — [PatternGallery](Examples/PatternGallery) для iOS и macOS, по одному экрану на каждый паттерн; CI собирает его для обеих платформ.
- **Порты для Flutter и React Native** — состояние представления, конечный автомат и отмена действий в виде пакета для Flutter (11 тестов) и пакета на TypeScript с React-хуком (17 тестов), в папке [`ports/`](ports).

## Быстрый старт

**1. Добавьте пакет**

В Xcode выберите **File › Add Package Dependencies…** и введите адрес репозитория:

```text
https://github.com/muhittincamdali/mobile-design-patterns.git
```

**2. Импортируйте модуль**

```swift
import MobilePatterns
```

**3. Используйте**

View model, которая загружает статьи через repository и отдаёт единое состояние представления. Обновление оставляет текущий список на экране, и неудачное обновление тоже оставляет его:

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

Представление читает `state.value` для списка, `state.isLoading` для индикатора выполнения и `state.failure` для баннера с ошибкой.

## Установка

### Swift Package Manager

В Xcode выберите **File › Add Package Dependencies…** и введите адрес репозитория:

```text
https://github.com/muhittincamdali/mobile-design-patterns.git
```

Или добавьте его в `dependencies` вашего `Package.swift`:

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

### Flutter и React Native

Порты не опубликованы в pub.dev и npm. Скопируйте `ports/flutter` или `ports/react-native` в свой проект либо подключите папку по пути; оба способа показаны в [ports/README.md](ports/README.md).

## Использование

Каждый пример ниже скопирован из [`ReadmeSamples.swift`](Examples/PatternGallery/PatternGallery/ReadmeSamples.swift); демонстрационное приложение компилирует этот файл, а тесты пакета его запускают.

### Отклонить второе нажатие с помощью конечного автомата

Переходы описаны одним `switch`. Пока автомат находится в состоянии `.paying`, событие `.pay` не разрешено, поэтому двойное нажатие списывает деньги один раз:

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

### Открыть deep link через router

`DeepLinkParser` проверяет scheme, host, учётные данные, сегменты `.` и `..`, кодировку, управляющие символы и размеры, прежде чем сопоставить ссылку с паттерном. Паттерн возвращает стек целиком, поэтому кнопка «Назад» работает:

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

В приложении стек отображает `NavigationStack(path: $router.path)`, а передаёт ему данные `.onOpenURL { router.open($0) }`.

### Добавить повторы, ограничение по времени и общий запрос с помощью decorator

`RequestBuilder` кодирует путь и query и отклоняет небезопасные заголовки; `AsyncLoader` добавляет поведение слоями, снаружи внутрь:

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

### Отменить правки с помощью command

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

### Обернуть SDK на callback

`withCompletion` сохраняет первый результат, игнорирует последующие callback и возвращает `CancellationError`, как только задача отменена:

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

### Отправить события нескольким слушателям

Каждый поток из `Broadcaster.events()` получает все последующие события и имеет собственный ограниченный буфер:

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

Дайте каждому слушателю его собственный поток (`badge.listen(to: cartEvents.events())`), а затем вызывайте `cartEvents.send(.added(itemID: 7))` везде, где меняется корзина.

## Демо

Экраны демонстрационного приложения на симуляторе iPhone, снятые с помощью [`scripts/capture-screens.sh`](scripts/capture-screens.sh):

| Состояние представления | Конечный автомат | Command и отмена | Observer | Deep link |
| --- | --- | --- | --- | --- |
| ![Состояние представления, светлая тема](docs/images/articles-light.png) | ![Конечный автомат, светлая тема](docs/images/checkout-light.png) | ![Command и отмена, светлая тема](docs/images/editor-light.png) | ![Observer, светлая тема](docs/images/cart-light.png) | ![Deep link, светлая тема](docs/images/links-light.png) |
| ![Состояние представления, тёмная тема](docs/images/articles-dark.png) | ![Конечный автомат, тёмная тема](docs/images/checkout-dark.png) | ![Command и отмена, тёмная тема](docs/images/editor-dark.png) | ![Observer, тёмная тема](docs/images/cart-dark.png) | ![Deep link, тёмная тема](docs/images/links-dark.png) |

Чтобы попробовать паттерны самостоятельно, откройте `PatternGallery.xcodeproj` из папки [`Examples/PatternGallery`](Examples/PatternGallery) в Xcode, выберите симулятор iPhone или **My Mac** и нажмите **Run**. В [Examples/README.md](Examples/README.md) также показано, как открыть deep link в запущенном приложении.

## Документация

Справочник API и статьи:

- [Справочник по API](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/)
  (DocC, публикуется в GitHub Pages из ветки `main`)
- Соберите его локально в Xcode через **Product › Build Documentation** или из командной строки:

```sh
xcodebuild docbuild -scheme MobilePatterns -destination 'generic/platform=macOS'
```

## Руководства

- [Getting Started](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/gettingstarted)
  — добавить пакет, заменить флаги загрузки одним значением, управлять навигацией через router
  ([исходник](Sources/MobilePatterns/MobilePatterns.docc/GettingStarted.md)).
- [Choosing a Pattern](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/choosingapattern)
  — от симптома в вашем коде к типу, который его решает, и когда ничего добавлять не нужно
  ([исходник](Sources/MobilePatterns/MobilePatterns.docc/ChoosingAPattern.md)).
- [Loading Data with View State](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/loadingdatawithviewstate)
  — политики кеша для каждого вызова, отрисовка каждого состояния, обновления «сначала кеш, затем свежие данные»
  ([исходник](Sources/MobilePatterns/MobilePatterns.docc/LoadingDataWithViewState.md)).
- [Opening Deep Links Safely](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/openingdeeplinkssafely)
  — проверки парсера по порядку, стеки вместо отдельных экранов, ошибки, которые не повторяют входные данные
  ([исходник](Sources/MobilePatterns/MobilePatterns.docc/OpeningDeepLinksSafely.md)).
- [Порты для Flutter и React Native](ports/README.md) — какие паттерны портированы и как запускать их тесты.

## Требования

| Платформа | Минимальная версия |
| --- | --- |
| iOS | 17 |
| macOS | 14 |
| Инструменты | Swift 6.2 · Xcode 26+ |
| Порт для Flutter | Flutter 3.41 · Dart 3.11 |
| Порт для React Native | React 19 · Node 22.22 для тестов |

## Архитектура

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

Проектные решения:

- **Типы-значения там, где состояние локально** (`Loadable`, `StateMachine`, `UndoStack`, `RequestBuilder`), **actor** там, где состоянием делятся вызывающие стороны (`Repository`), и блокировка там, где из любого потока нужен синхронный API (`Broadcaster`, `withCompletion`).
- **Ограничено по умолчанию.** У глубины router, ёмкости repository, истории отмены, буферов broadcaster и размеров deep link есть пределы; значения ниже минимума поднимаются до него вместо аварийного завершения.
- **Внешний ввод проверяется до использования.** Deep link и части запросов проверяются, а ошибки не содержат копии отклонённого ввода.
- **README не устаревает.** Его примеры лежат в Swift-файле, который собирает демонстрационное приложение и запускают тесты.

## План развития

- Добавить пакет в Swift Package Index после выпуска 2.0.0; `.spi.yml` уже есть в репозитории.
- Портировать `DeepLinkParser` на Dart и TypeScript, где те же проверки применимы к ссылкам `go_router` и React Navigation.
- Debouncer для полей поиска с тестовыми часами.

## Участие в разработке

Мы рады вашему участию. Перед открытием pull request прочитайте [руководство для участников](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/CONTRIBUTING.md) и [кодекс поведения](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/CODE_OF_CONDUCT.md). О проблемах безопасности сообщайте конфиденциально, как описано в [политике безопасности](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/SECURITY.md).

## Лицензия

Распространяется по лицензии MIT. Подробнее — в файле [LICENSE](LICENSE).
