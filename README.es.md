<!-- i18n-source: README.md@3069f4f22d45f2e06ad067de36ff81918c555181 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-light.svg" alt="Mobile Design Patterns: Design patterns for iOS and macOS apps as tested Swift types, with Flutter and React Native ports."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/mobile-design-patterns/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/mobile-design-patterns/actions/workflows/ci.yml/badge.svg" alt="Estado de CI"></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-light.svg" alt="Última versión: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-light.svg" alt="Plataformas compatibles: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-light.svg" alt="Versión del lenguaje: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-light.svg" alt="Licencia: MIT"></picture></a>
</p>

<p align="center">
<a href="#inicio-rápido"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-es-light.svg" alt="Empezar"></picture></a>
<a href="https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-es-light.svg" alt="Documentación"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-es-light.svg" alt="Ejemplos"></picture></a>
</p>

> Esta es una traducción del README en inglés. Si hay diferencias, la versión en inglés es la vigente.

<!-- brand:end -->

Un paquete Swift de patrones de diseño para apps de iOS y macOS, escritos como tipos pequeños que puedes usar de uno en uno: estado de vista, máquina de estados, coordinator y deep links, repository, decorators, adapter, observer, command con deshacer y builder. Está pensado para desarrolladores de apps que conocen los nombres de los patrones y quieren una versión que aguante en una app real: una que rechaza un segundo toque mientras se procesa un pago, que sobrevive a un completion handler llamado dos veces y que rechaza un deep link con `..` en su ruta. Cada patrón tiene pruebas, los ejemplos del README se compilan y se ejecutan como pruebas, y una app de ejemplo muestra cada uno en pantalla. El estado de vista, la máquina de estados y deshacer también están disponibles como paquetes de Flutter y React Native.

## Lo más destacado

- **Un tipo por patrón** — `Loadable`, `StateMachine`, `Router`, `DeepLinkParser`,
  `Repository`, `AsyncLoader`, `withCompletion`, `Broadcaster`, `UndoStack` y
  `RequestBuilder`; sin clases base, sin ningún framework que adoptar y sin dependencias.
- **Casos límite resueltos y probados** — las cargas que otra más reciente adelanta no se guardan en caché, una recarga mantiene la lista en pantalla, una cancelación nunca se reintenta, un suscriptor lento no puede hacer crecer la memoria, se rechazan los valores de cabecera con saltos de línea y los parámetros numéricos de un enlace no pueden hacer fallar la app por desbordamiento.
- **Modo de lenguaje Swift 6** — el paquete se compila con comprobación estricta de concurrencia y sin advertencias; el estado compartido vive en actors o detrás de un bloqueo.
- **Probado** — 103 pruebas de Swift Testing en macOS y 102 en un simulador de iPhone (las exit tests solo se ejecutan en macOS), incluidos los ejemplos del README y el cliente real de la app de ejemplo frente a un `URLSession` simulado con stubs.
- **App de ejemplo** — [PatternGallery](Examples/PatternGallery) para iOS y macOS, con una pantalla por patrón; CI la compila para ambas plataformas.
- **Ports a Flutter y React Native** — estado de vista, máquina de estados y deshacer como paquete de Flutter (11 pruebas) y como paquete de TypeScript con un hook de React (17 pruebas), en [`ports/`](ports).

## Inicio rápido

**1. Añade el paquete**

En Xcode, elige **File › Add Package Dependencies…** e introduce la URL del repositorio:

```text
https://github.com/muhittincamdali/mobile-design-patterns.git
```

**2. Importa el módulo**

```swift
import MobilePatterns
```

**3. Úsalo**

Un view model que carga artículos a través de un repository y expone un único estado de vista. Al refrescar, la lista actual se mantiene en pantalla, y si el refresco falla, también:

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

La vista lee `state.value` para la lista, `state.isLoading` para el indicador de progreso y `state.failure` para el banner de error.

## Instalación

### Swift Package Manager

En Xcode, elige **File › Add Package Dependencies…** e introduce la URL del repositorio:

```text
https://github.com/muhittincamdali/mobile-design-patterns.git
```

O añádelo a las `dependencies` de tu `Package.swift`:

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

### Flutter y React Native

Los ports no se publican en pub.dev ni en npm. Copia `ports/flutter` o `ports/react-native` en tu proyecto, o depende de la carpeta por ruta; [ports/README.md](ports/README.md) muestra ambas opciones.

## Uso

Todos los ejemplos de abajo están copiados de [`ReadmeSamples.swift`](Examples/PatternGallery/PatternGallery/ReadmeSamples.swift), que la app de ejemplo compila y las pruebas del paquete ejecutan.

### Rechazar un segundo toque con una máquina de estados

Las transiciones son un único `switch`. Mientras la máquina está en `.paying`, `.pay` no se permite, así que un doble toque cobra una sola vez:

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

### Abrir deep links mediante un router

`DeepLinkParser` comprueba el scheme, el host, las credenciales, los segmentos `.` y `..`, una `/` o `\` codificada dentro de un segmento (`%2F`, `%5C`), la codificación, los caracteres de control y los tamaños antes de comparar con un patrón. Un patrón devuelve la pila completa, de modo que el botón de retroceso funciona:

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

En la app, `NavigationStack(path: $router.path)` muestra la pila y `.onOpenURL { router.open($0) }` la alimenta.

### Añadir reintentos, un límite de tiempo y petición compartida con decorators

`RequestBuilder` codifica la ruta y la consulta y rechaza cabeceras inseguras; `AsyncLoader` añade comportamiento por capas, de fuera hacia dentro:

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

### Deshacer ediciones con commands

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

### Envolver un SDK basado en callbacks

`withCompletion` conserva el primer resultado, ignora los callbacks posteriores y devuelve `CancellationError` en cuanto se cancela la tarea:

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

### Enviar eventos a varios oyentes

Cada stream de `Broadcaster.events()` recibe todos los eventos posteriores, con su propio búfer acotado:

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

Dale a cada oyente su propio stream (`badge.listen(to: cartEvents.events())`) y llama a `cartEvents.send(.added(itemID: 7))` allí donde cambie el carrito.

## Demo

Pantallas de la app de ejemplo en un simulador de iPhone, capturadas con [`scripts/capture-screens.sh`](scripts/capture-screens.sh):

| Estado de vista | Máquina de estados | Command y deshacer | Observer | Deep links |
| --- | --- | --- | --- | --- |
| ![Estado de vista, claro](docs/images/articles-light.png) | ![Máquina de estados, claro](docs/images/checkout-light.png) | ![Command y deshacer, claro](docs/images/editor-light.png) | ![Observer, claro](docs/images/cart-light.png) | ![Deep links, claro](docs/images/links-light.png) |
| ![Estado de vista, oscuro](docs/images/articles-dark.png) | ![Máquina de estados, oscuro](docs/images/checkout-dark.png) | ![Command y deshacer, oscuro](docs/images/editor-dark.png) | ![Observer, oscuro](docs/images/cart-dark.png) | ![Deep links, oscuro](docs/images/links-dark.png) |

Para probar los patrones tú mismo, abre `PatternGallery.xcodeproj` en [`Examples/PatternGallery`](Examples/PatternGallery) con Xcode, elige un simulador de iPhone o **My Mac** y pulsa **Run**. [Examples/README.md](Examples/README.md) también explica cómo abrir un deep link en la app en ejecución.

## Documentación

Referencia de la API y artículos:

- [Referencia de la API](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/)
  (DocC, publicada en GitHub Pages desde `main`)
- Compílala en local en Xcode con **Product › Build Documentation**, o desde la línea de comandos:

```sh
xcodebuild docbuild -scheme MobilePatterns -destination 'generic/platform=macOS'
```

## Guías

- [Getting Started](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/gettingstarted)
  — añade el paquete, sustituye los indicadores de carga por un único valor y gobierna la navegación desde un router
  ([código fuente](Sources/MobilePatterns/MobilePatterns.docc/GettingStarted.md)).
- [Choosing a Pattern](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/choosingapattern)
  — de un síntoma en tu código al tipo que lo resuelve, y cuándo no añadir ninguno
  ([código fuente](Sources/MobilePatterns/MobilePatterns.docc/ChoosingAPattern.md)).
- [Loading Data with View State](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/loadingdatawithviewstate)
  — políticas de caché por llamada, dibujar cada estado, actualizaciones de caché y luego datos frescos
  ([código fuente](Sources/MobilePatterns/MobilePatterns.docc/LoadingDataWithViewState.md)).
- [Opening Deep Links Safely](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/openingdeeplinkssafely)
  — las comprobaciones del parser en orden, pilas en lugar de pantallas sueltas, errores que no repiten la entrada
  ([código fuente](Sources/MobilePatterns/MobilePatterns.docc/OpeningDeepLinksSafely.md)).
- [Ports a Flutter y React Native](ports/README.md) — qué patrones están portados y cómo ejecutar sus pruebas.

## Requisitos

| Plataforma | Versión mínima |
| --- | --- |
| iOS | 17 |
| macOS | 14 |
| Herramientas | Swift 6.2 · Xcode 26+ |
| Port de Flutter | Flutter 3.41 · Dart 3.11 |
| Port de React Native | React 19 · Node 22.22 para las pruebas |

## Arquitectura

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

Decisiones de diseño:

- **Tipos de valor donde el estado es local** (`Loadable`, `StateMachine`, `UndoStack`, `RequestBuilder`), un **actor** donde los llamadores comparten estado (`Repository`) y un bloqueo donde se necesita una API síncrona desde cualquier hilo (`Broadcaster`, `withCompletion`).
- **Acotado por defecto.** La profundidad del router, la capacidad del repository, el historial de deshacer, los búferes del broadcaster y los tamaños de los deep links tienen límites; los valores por debajo del mínimo se elevan a él en lugar de hacer fallar la app.
- **La entrada externa se comprueba antes de usarla.** Los deep links y las partes de las peticiones se validan, y los errores no llevan copia de la entrada rechazada.
- **El README no se desfasa.** Sus ejemplos viven en un archivo Swift que la app de ejemplo compila y que las pruebas ejecutan.

## Hoja de ruta

- Añadir el paquete al Swift Package Index tras la versión 2.0.0; `.spi.yml` ya está en el repositorio.
- Portar `DeepLinkParser` a Dart y TypeScript, donde las mismas comprobaciones se aplican a los enlaces de `go_router` y React Navigation.
- Un debouncer para campos de búsqueda, con un reloj de pruebas.

## Contribuir

Las contribuciones son bienvenidas. Lee la [guía de contribución](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/CONTRIBUTING.md) y el [código de conducta](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/CODE_OF_CONDUCT.md) antes de abrir una pull request. Informa de los problemas de seguridad de forma privada, como se describe en la [política de seguridad](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/SECURITY.md).

## Licencia

Publicado bajo la licencia MIT. Consulta [LICENSE](LICENSE).
