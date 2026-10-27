<!-- i18n-source: README.md@71ad011be475bbe9b9383401e2ebea4ec421dc04 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-light.svg" alt="Mobile Design Patterns: Design patterns for iOS and macOS apps as tested Swift types, with Flutter and React Native ports."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/mobile-design-patterns/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/mobile-design-patterns/actions/workflows/ci.yml/badge.svg" alt="État de la CI"></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-light.svg" alt="Dernière version: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-light.svg" alt="Plateformes prises en charge: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-light.svg" alt="Version du langage: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-light.svg" alt="Licence: MIT"></picture></a>
</p>

<p align="center">
<a href="#démarrage-rapide"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-fr-light.svg" alt="Commencer"></picture></a>
<a href="https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-fr-light.svg" alt="Documentation"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-fr-light.svg" alt="Exemples"></picture></a>
</p>

> Ceci est une traduction du README anglais. En cas de différence, la version anglaise fait foi.

<!-- brand:end -->

Un paquet Swift de design patterns pour les apps iOS et macOS, écrits sous forme de petits types que vous pouvez utiliser un par un : état de vue, machine à états, coordinator et deep links, repository, decorators, adapter, observer, command avec annulation et builder. Il s’adresse aux développeurs d’apps qui connaissent le nom des patterns et veulent une version qui tienne dans une vraie app : une version qui refuse un second appui pendant qu’un paiement est en cours, qui supporte un completion handler appelé deux fois et qui rejette un deep link contenant `..` dans son chemin. Chaque pattern a ses tests, les exemples du README sont compilés et exécutés comme des tests, et une app d’exemple montre chacun d’eux à l’écran. L’état de vue, la machine à états et l’annulation existent aussi sous forme de paquets Flutter et React Native.

## Points forts

- **Un type par pattern** — `Loadable`, `StateMachine`, `Router`, `DeepLinkParser`,
  `Repository`, `AsyncLoader`, `withCompletion`, `Broadcaster`, `UndoStack` et
  `RequestBuilder` ; pas de classes de base, aucun framework à adopter, aucune dépendance.
- **Cas limites gérés et testés** — les chargements dépassés par un plus récent ne sont pas mis en cache, un rechargement garde la liste à l’écran, une annulation n’est jamais retentée, un abonné lent ne peut pas faire grossir la mémoire, les valeurs d’en-tête contenant des sauts de ligne sont refusées, et les paramètres numériques d’un lien ne peuvent pas provoquer de plantage en cas de dépassement.
- **Mode de langage Swift 6** — le paquet se compile avec la vérification stricte de la concurrence et sans avertissement ; l’état partagé vit dans des actors ou derrière un verrou.
- **Testé** — 103 tests Swift Testing sur macOS et 102 sur un simulateur d’iPhone (les exit tests ne s’exécutent que sur macOS), y compris les exemples du README et le client réel de l’app d’exemple face à une `URLSession` simulée par des stubs.
- **App d’exemple** — [PatternGallery](Examples/PatternGallery) pour iOS et macOS, avec un écran par pattern ; la CI la compile pour les deux plateformes.
- **Ports Flutter et React Native** — état de vue, machine à états et annulation sous forme de paquet Flutter (11 tests) et de paquet TypeScript avec un hook React (17 tests), dans [`ports/`](ports).

## Démarrage rapide

**1. Ajouter le paquet**

Dans Xcode, choisissez **File › Add Package Dependencies…** et saisissez l’URL du dépôt :

```text
https://github.com/muhittincamdali/mobile-design-patterns.git
```

**2. Importer le module**

```swift
import MobilePatterns
```

**3. L’utiliser**

Un view model qui charge des articles via un repository et expose un seul état de vue. Une actualisation garde la liste actuelle à l’écran, et une actualisation qui échoue la garde aussi :

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

La vue lit `state.value` pour la liste, `state.isLoading` pour l’indicateur de progression et `state.failure` pour le bandeau d’erreur.

## Installation

### Swift Package Manager

Dans Xcode, choisissez **File › Add Package Dependencies…** et saisissez l’URL du dépôt :

```text
https://github.com/muhittincamdali/mobile-design-patterns.git
```

Ou ajoutez-le aux `dependencies` de votre `Package.swift` :

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

### Flutter et React Native

Les ports ne sont publiés ni sur pub.dev ni sur npm. Copiez `ports/flutter` ou `ports/react-native` dans votre projet, ou dépendez du dossier par son chemin ; [ports/README.md](ports/README.md) montre les deux.

## Utilisation

Chaque exemple ci-dessous est copié depuis [`ReadmeSamples.swift`](Examples/PatternGallery/PatternGallery/ReadmeSamples.swift), que l’app d’exemple compile et que les tests du paquet exécutent.

### Refuser un second appui avec une machine à états

Les transitions tiennent dans un seul `switch`. Tant que la machine est dans l’état `.paying`, `.pay` n’est pas autorisé, si bien qu’un double appui ne débite qu’une fois :

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

### Ouvrir des deep links via un router

`DeepLinkParser` vérifie le scheme, l’hôte, les identifiants, les segments `.` et `..`, un `/` ou un `\` encodé dans un segment (`%2F`, `%5C`), l’encodage, les caractères de contrôle et les tailles avant de chercher une correspondance avec un pattern. Un pattern renvoie la pile entière, de sorte que le bouton Retour fonctionne :

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

Dans l’app, `NavigationStack(path: $router.path)` affiche la pile et `.onOpenURL { router.open($0) }` l’alimente.

### Ajouter des nouvelles tentatives, une limite de temps et le partage de requêtes avec des decorators

`RequestBuilder` encode le chemin et la requête et refuse les en-têtes dangereux ; `AsyncLoader` ajoute des comportements par couches, de l’extérieur vers l’intérieur :

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

### Annuler des modifications avec des commands

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

### Encapsuler un SDK à callbacks

`withCompletion` garde le premier résultat, ignore les callbacks suivants et renvoie `CancellationError` dès que la tâche est annulée :

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

### Envoyer des événements à plusieurs écouteurs

Chaque flux issu de `Broadcaster.events()` reçoit tous les événements suivants, avec son propre tampon borné :

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

Donnez à chaque écouteur son propre flux (`badge.listen(to: cartEvents.events())`), puis appelez `cartEvents.send(.added(itemID: 7))` partout où le panier change.

## Démo

Écrans de l’app d’exemple sur un simulateur d’iPhone, capturés par [`scripts/capture-screens.sh`](scripts/capture-screens.sh) :

| État de vue | Machine à états | Command et annulation | Observer | Deep links |
| --- | --- | --- | --- | --- |
| ![État de vue, clair](docs/images/articles-light.png) | ![Machine à états, clair](docs/images/checkout-light.png) | ![Command et annulation, clair](docs/images/editor-light.png) | ![Observer, clair](docs/images/cart-light.png) | ![Deep links, clair](docs/images/links-light.png) |
| ![État de vue, sombre](docs/images/articles-dark.png) | ![Machine à états, sombre](docs/images/checkout-dark.png) | ![Command et annulation, sombre](docs/images/editor-dark.png) | ![Observer, sombre](docs/images/cart-dark.png) | ![Deep links, sombre](docs/images/links-dark.png) |

Pour essayer les patterns vous-même, ouvrez `PatternGallery.xcodeproj` dans [`Examples/PatternGallery`](Examples/PatternGallery) avec Xcode, choisissez un simulateur d’iPhone ou **My Mac**, puis appuyez sur **Run**. [Examples/README.md](Examples/README.md) explique aussi comment ouvrir un deep link dans l’app en cours d’exécution.

## Documentation

Référence de l’API et articles :

- [Référence de l’API](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/)
  (DocC, publiée sur GitHub Pages depuis `main`)
- Générez-la en local dans Xcode avec **Product › Build Documentation**, ou en ligne de commande :

```sh
xcodebuild docbuild -scheme MobilePatterns -destination 'generic/platform=macOS'
```

## Guides

- [Getting Started](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/gettingstarted)
  — ajouter le paquet, remplacer les indicateurs de chargement par une seule valeur, piloter la navigation depuis un router
  ([source](Sources/MobilePatterns/MobilePatterns.docc/GettingStarted.md)).
- [Choosing a Pattern](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/choosingapattern)
  — d’un symptôme dans votre code au type qui y répond, et quand ne pas en ajouter
  ([source](Sources/MobilePatterns/MobilePatterns.docc/ChoosingAPattern.md)).
- [Loading Data with View State](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/loadingdatawithviewstate)
  — politiques de cache par appel, affichage de chaque état, mises à jour « cache d’abord, données fraîches ensuite »
  ([source](Sources/MobilePatterns/MobilePatterns.docc/LoadingDataWithViewState.md)).
- [Opening Deep Links Safely](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/openingdeeplinkssafely)
  — les vérifications du parser dans l’ordre, des piles plutôt que des écrans isolés, des erreurs qui ne renvoient pas l’entrée
  ([source](Sources/MobilePatterns/MobilePatterns.docc/OpeningDeepLinksSafely.md)).
- [Ports Flutter et React Native](ports/README.md) — quels patterns sont portés, et comment exécuter leurs tests.

## Prérequis

| Plateforme | Version minimale |
| --- | --- |
| iOS | 17 |
| macOS | 14 |
| Chaîne d’outils | Swift 6.2 · Xcode 26+ |
| Port Flutter | Flutter 3.41 · Dart 3.11 |
| Port React Native | React 19 · Node 22.22 pour les tests |

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

Choix de conception :

- **Des types valeur là où l’état est local** (`Loadable`, `StateMachine`, `UndoStack`, `RequestBuilder`), un **actor** là où les appelants partagent l’état (`Repository`), et un verrou là où une API synchrone est nécessaire depuis n’importe quel thread (`Broadcaster`, `withCompletion`).
- **Borné par défaut.** La profondeur du router, la capacité du repository, l’historique d’annulation, les tampons du broadcaster et les tailles des deep links ont tous des limites ; les valeurs inférieures au minimum sont relevées à celui-ci au lieu de provoquer un plantage.
- **Les entrées extérieures sont vérifiées avant d’être utilisées.** Les deep links et les éléments de requête sont validés, et les erreurs ne contiennent aucune copie de l’entrée rejetée.
- **Le README ne peut pas dériver.** Ses exemples se trouvent dans un fichier Swift que l’app d’exemple compile et que les tests exécutent.

## Feuille de route

- Ajouter le paquet au Swift Package Index après la version 2.0.0 ; `.spi.yml` est déjà dans le dépôt.
- Porter `DeepLinkParser` vers Dart et TypeScript, où les mêmes vérifications s’appliquent aux liens de `go_router` et de React Navigation.
- Un debouncer pour les champs de recherche, avec une horloge de test.

## Contribuer

Les contributions sont les bienvenues. Lisez le [guide de contribution](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/CONTRIBUTING.md) et le [code de conduite](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/CODE_OF_CONDUCT.md) avant d’ouvrir une pull request. Signalez les problèmes de sécurité en privé, comme indiqué dans la [politique de sécurité](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/SECURITY.md).

## Licence

Publié sous licence MIT. Voir [LICENSE](LICENSE).
