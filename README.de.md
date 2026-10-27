<!-- i18n-source: README.md@71ad011be475bbe9b9383401e2ebea4ec421dc04 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-light.svg" alt="Mobile Design Patterns: Design patterns for iOS and macOS apps as tested Swift types, with Flutter and React Native ports."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/mobile-design-patterns/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/mobile-design-patterns/actions/workflows/ci.yml/badge.svg" alt="CI-Status"></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-light.svg" alt="Aktuelle Version: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-light.svg" alt="Unterstützte Plattformen: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-light.svg" alt="Sprachversion: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-light.svg" alt="Lizenz: MIT"></picture></a>
</p>

<p align="center">
<a href="#schnellstart"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-de-light.svg" alt="Loslegen"></picture></a>
<a href="https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-de-light.svg" alt="Dokumentation"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-de-light.svg" alt="Beispiele"></picture></a>
</p>

> Dies ist eine Übersetzung der englischen README. Bei Abweichungen gilt die englische Fassung.

<!-- brand:end -->

Ein Swift-Paket mit Entwurfsmustern für iOS- und macOS-Apps, geschrieben als kleine Typen, die du einzeln einsetzen kannst: View-State, State Machine, Coordinator und Deep Links, Repository, Decorators, Adapter, Observer, Command mit Rückgängig-Funktion und Builder. Es richtet sich an App-Entwickler, die die Namen der Muster kennen und eine Variante suchen, die in einer echten App standhält: eine, die einen zweiten Tipp abweist, während eine Zahlung läuft, die einen doppelt aufgerufenen Completion-Handler übersteht und einen Deep Link mit `..` im Pfad zurückweist. Jedes Muster hat Tests, die README-Beispiele werden als Tests kompiliert und ausgeführt, und eine Beispiel-App zeigt jedes Muster auf dem Bildschirm. View-State, State Machine und Rückgängig gibt es auch als Flutter- und React-Native-Pakete.

## Highlights

- **Ein Typ pro Muster** — `Loadable`, `StateMachine`, `Router`, `DeepLinkParser`,
  `Repository`, `AsyncLoader`, `withCompletion`, `Broadcaster`, `UndoStack` und
  `RequestBuilder`; keine Basisklassen, kein Framework, das du übernehmen musst, keine Abhängigkeiten.
- **Grenzfälle behandelt und getestet** — von neueren Anfragen überholte Abrufe werden nicht zwischengespeichert, ein Neuladen lässt die Liste auf dem Bildschirm stehen, ein Abbruch wird nie wiederholt, ein langsamer Abonnent kann den Speicher nicht anwachsen lassen, Header-Werte mit Zeilenumbrüchen werden abgelehnt, und numerische Link-Parameter können bei einem Überlauf nicht abstürzen.
- **Swift-6-Sprachmodus** — das Paket baut mit strenger Concurrency-Prüfung und ohne Warnungen; geteilter Zustand liegt in Actors oder hinter einer Sperre.
- **Getestet** — 103 Swift-Testing-Tests auf macOS und 102 auf einem iPhone-Simulator (Exit-Tests laufen nur auf macOS), darunter die README-Beispiele und der echte Client der Beispiel-App gegen eine per Stub ersetzte `URLSession`.
- **Beispiel-App** — [PatternGallery](Examples/PatternGallery) für iOS und macOS, mit einem Bildschirm pro Muster; CI baut sie für beide Plattformen.
- **Flutter- und React-Native-Ports** — View-State, State Machine und Rückgängig als Flutter-Paket (11 Tests) und als TypeScript-Paket mit einem React-Hook (17 Tests), in [`ports/`](ports).

## Schnellstart

**1. Paket hinzufügen**

Wähle in Xcode **File › Add Package Dependencies…** und gib die Repository-URL ein:

```text
https://github.com/muhittincamdali/mobile-design-patterns.git
```

**2. Modul importieren**

```swift
import MobilePatterns
```

**3. Verwenden**

Ein View-Model, das Artikel über ein Repository lädt und einen einzigen View-State bereitstellt. Beim Aktualisieren bleibt die aktuelle Liste auf dem Bildschirm, und bei einer fehlgeschlagenen Aktualisierung bleibt sie ebenfalls stehen:

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

Die View liest `state.value` für die Liste, `state.isLoading` für die Fortschrittsanzeige und `state.failure` für das Fehlerbanner.

## Installation

### Swift Package Manager

Wähle in Xcode **File › Add Package Dependencies…** und gib die Repository-URL ein:

```text
https://github.com/muhittincamdali/mobile-design-patterns.git
```

Oder füge es zu den `dependencies` in deiner `Package.swift` hinzu:

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

### Flutter und React Native

Die Ports sind nicht auf pub.dev oder npm veröffentlicht. Kopiere `ports/flutter` oder `ports/react-native` in dein Projekt oder binde den Ordner per Pfad ein; [ports/README.md](ports/README.md) zeigt beides.

## Verwendung

Jedes Beispiel unten ist aus [`ReadmeSamples.swift`](Examples/PatternGallery/PatternGallery/ReadmeSamples.swift) kopiert, das die Beispiel-App kompiliert und die Paket-Tests ausführen.

### Einen zweiten Tipp mit einer State Machine abweisen

Die Übergänge sind ein einziges `switch`. Solange die Maschine in `.paying` ist, ist `.pay` nicht erlaubt, sodass ein Doppeltipp nur einmal abbucht:

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

### Deep Links über einen Router öffnen

`DeepLinkParser` prüft Scheme, Host, Zugangsdaten, `.`- und `..`-Segmente, ein in einem Segment kodiertes `/` oder `\` (`%2F`, `%5C`), Kodierung, Steuerzeichen und Größen, bevor er ein Muster abgleicht. Ein Muster liefert den ganzen Stack, sodass die Zurück-Schaltfläche funktioniert:

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

In der App zeigt `NavigationStack(path: $router.path)` den Stack an, und `.onOpenURL { router.open($0) }` speist ihn.

### Wiederholungen, ein Zeitlimit und geteilte Anfragen mit Decorators ergänzen

`RequestBuilder` kodiert Pfad und Query und lehnt unsichere Header ab; `AsyncLoader` fügt Verhalten in Schichten hinzu, von außen nach innen:

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

### Änderungen mit Commands rückgängig machen

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

### Ein Callback-SDK umhüllen

`withCompletion` behält das erste Ergebnis, ignoriert spätere Callbacks und liefert `CancellationError`, sobald der Task abgebrochen wird:

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

### Ereignisse an mehrere Listener senden

Jeder Stream aus `Broadcaster.events()` erhält alle späteren Ereignisse, mit einem eigenen begrenzten Puffer:

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

Gib jedem Listener seinen eigenen Stream (`badge.listen(to: cartEvents.events())`) und rufe dann überall dort `cartEvents.send(.added(itemID: 7))` auf, wo sich der Warenkorb ändert.

## Demo

Bildschirme der Beispiel-App auf einem iPhone-Simulator, aufgenommen mit [`scripts/capture-screens.sh`](scripts/capture-screens.sh):

| View-State | State Machine | Command und Rückgängig | Observer | Deep Links |
| --- | --- | --- | --- | --- |
| ![View-State, hell](docs/images/articles-light.png) | ![State Machine, hell](docs/images/checkout-light.png) | ![Command und Rückgängig, hell](docs/images/editor-light.png) | ![Observer, hell](docs/images/cart-light.png) | ![Deep Links, hell](docs/images/links-light.png) |
| ![View-State, dunkel](docs/images/articles-dark.png) | ![State Machine, dunkel](docs/images/checkout-dark.png) | ![Command und Rückgängig, dunkel](docs/images/editor-dark.png) | ![Observer, dunkel](docs/images/cart-dark.png) | ![Deep Links, dunkel](docs/images/links-dark.png) |

Um die Muster selbst auszuprobieren, öffne `PatternGallery.xcodeproj` in [`Examples/PatternGallery`](Examples/PatternGallery) mit Xcode, wähle einen iPhone-Simulator oder **My Mac** und drücke **Run**. [Examples/README.md](Examples/README.md) zeigt außerdem, wie du in der laufenden App einen Deep Link öffnest.

## Dokumentation

API-Referenz und Artikel:

- [API-Referenz](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/)
  (DocC, von `main` auf GitHub Pages veröffentlicht)
- Lokal baust du sie in Xcode mit **Product › Build Documentation** oder über die Kommandozeile:

```sh
xcodebuild docbuild -scheme MobilePatterns -destination 'generic/platform=macOS'
```

## Anleitungen

- [Getting Started](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/gettingstarted)
  — das Paket hinzufügen, Lade-Flags durch einen einzigen Wert ersetzen, die Navigation von einem Router steuern lassen
  ([Quelle](Sources/MobilePatterns/MobilePatterns.docc/GettingStarted.md)).
- [Choosing a Pattern](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/choosingapattern)
  — vom Symptom in deinem Code zum passenden Typ, und wann man keinen hinzufügen sollte
  ([Quelle](Sources/MobilePatterns/MobilePatterns.docc/ChoosingAPattern.md)).
- [Loading Data with View State](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/loadingdatawithviewstate)
  — Cache-Richtlinien pro Aufruf, jeden Zustand darstellen, erst zwischengespeicherte, dann frische Daten anzeigen
  ([Quelle](Sources/MobilePatterns/MobilePatterns.docc/LoadingDataWithViewState.md)).
- [Opening Deep Links Safely](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/openingdeeplinkssafely)
  — die Prüfungen des Parsers in ihrer Reihenfolge, Stacks statt einzelner Bildschirme, Fehler, die die Eingabe nicht wiedergeben
  ([Quelle](Sources/MobilePatterns/MobilePatterns.docc/OpeningDeepLinksSafely.md)).
- [Flutter- und React-Native-Ports](ports/README.md) — welche Muster portiert sind und wie du ihre Tests ausführst.

## Voraussetzungen

| Plattform | Mindestversion |
| --- | --- |
| iOS | 17 |
| macOS | 14 |
| Toolchain | Swift 6.2 · Xcode 26+ |
| Flutter-Port | Flutter 3.41 · Dart 3.11 |
| React-Native-Port | React 19 · Node 22.22 für die Tests |

## Architektur

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

Entwurfsentscheidungen:

- **Wertetypen, wo der Zustand lokal ist** (`Loadable`, `StateMachine`, `UndoStack`, `RequestBuilder`), ein **Actor**, wo Aufrufer Zustand teilen (`Repository`), und eine Sperre, wo von jedem Thread aus eine synchrone API gebraucht wird (`Broadcaster`, `withCompletion`).
- **Standardmäßig begrenzt.** Router-Tiefe, Repository-Kapazität, Rückgängig-Verlauf, Broadcaster-Puffer und Deep-Link-Größen haben alle Grenzen; Werte unter dem Minimum werden auf dieses angehoben, statt abzustürzen.
- **Eingaben von außen werden vor der Verwendung geprüft.** Deep Links und Teile von Anfragen werden validiert, und Fehler enthalten keine Kopie der abgelehnten Eingabe.
- **Die README veraltet nicht.** Ihre Beispiele stehen in einer Swift-Datei, die die Beispiel-App baut und die Tests ausführen.

## Roadmap

- Das Paket nach dem Release 2.0.0 zum Swift Package Index hinzufügen; `.spi.yml` liegt bereits im Repository.
- `DeepLinkParser` nach Dart und TypeScript portieren, wo dieselben Prüfungen für `go_router`- und React-Navigation-Links gelten.
- Ein Debouncer für Suchfelder, mit einer Test-Uhr.

## Mitwirken

Beiträge sind willkommen. Lies vor einem Pull Request den [Leitfaden für Beiträge](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/CONTRIBUTING.md) und den [Verhaltenskodex](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/CODE_OF_CONDUCT.md). Sicherheitsprobleme meldest du vertraulich, wie in der [Sicherheitsrichtlinie](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/SECURITY.md) beschrieben.

## Lizenz

Veröffentlicht unter der MIT-Lizenz. Siehe [LICENSE](LICENSE).
