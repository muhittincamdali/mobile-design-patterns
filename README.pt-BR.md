<!-- i18n-source: README.md@3069f4f22d45f2e06ad067de36ff81918c555181 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/banner-light.svg" alt="Mobile Design Patterns: Design patterns for iOS and macOS apps as tested Swift types, with Flutter and React Native ports."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/mobile-design-patterns/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/mobile-design-patterns/actions/workflows/ci.yml/badge.svg" alt="Status da CI"></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-version-light.svg" alt="Versão mais recente: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-platforms-light.svg" alt="Plataformas compatíveis: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-language-light.svg" alt="Versão da linguagem: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/badge-license-light.svg" alt="Licença: MIT"></picture></a>
</p>

<p align="center">
<a href="#início-rápido"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-start-pt-BR-light.svg" alt="Começar"></picture></a>
<a href="https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-docs-pt-BR-light.svg" alt="Documentação"></picture></a>
<a href="https://github.com/muhittincamdali/mobile-design-patterns/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/mobile-design-patterns/main/.github/brand/button-examples-pt-BR-light.svg" alt="Exemplos"></picture></a>
</p>

> Esta é uma tradução do README em inglês. Se houver diferença, vale a versão em inglês.

<!-- brand:end -->

Um pacote Swift de padrões de projeto para apps iOS e macOS, escritos como tipos pequenos que você pode usar um de cada vez: estado de view, máquina de estados, coordinator e deep links, repository, decorators, adapter, observer, command com desfazer e builder. Ele é voltado a desenvolvedores de apps que conhecem os nomes dos padrões e querem uma versão que aguente um app de verdade: uma que recusa um segundo toque enquanto um pagamento está em andamento, que sobrevive a um completion handler chamado duas vezes e que rejeita um deep link com `..` no caminho. Todo padrão tem testes, os exemplos do README são compilados e executados como testes, e um app de exemplo mostra cada um deles na tela. O estado de view, a máquina de estados e o desfazer também estão disponíveis como pacotes Flutter e React Native.

## Destaques

- **Um tipo por padrão** — `Loadable`, `StateMachine`, `Router`, `DeepLinkParser`,
  `Repository`, `AsyncLoader`, `withCompletion`, `Broadcaster`, `UndoStack` e
  `RequestBuilder`; sem classes base, sem framework para adotar, sem dependências.
- **Casos extremos tratados e testados** — buscas ultrapassadas por outras mais recentes não vão para o cache, um recarregamento mantém a lista na tela, um cancelamento nunca é repetido, um assinante lento não consegue fazer a memória crescer, valores de cabeçalho com quebras de linha são recusados e parâmetros numéricos de links não derrubam o app em caso de estouro.
- **Modo de linguagem Swift 6** — o pacote compila com verificação estrita de concorrência e sem avisos; o estado compartilhado fica em actors ou atrás de um lock.
- **Testado** — 103 testes do Swift Testing no macOS e 102 em um simulador de iPhone (os exit tests rodam só no macOS), incluindo os exemplos do README e o cliente real do app de exemplo contra uma `URLSession` simulada com stubs.
- **App de exemplo** — [PatternGallery](Examples/PatternGallery) para iOS e macOS, com uma tela por padrão; a CI o compila para as duas plataformas.
- **Ports para Flutter e React Native** — estado de view, máquina de estados e desfazer como um pacote Flutter (11 testes) e um pacote TypeScript com um hook do React (17 testes), em [`ports/`](ports).

## Início rápido

**1. Adicione o pacote**

No Xcode, escolha **File › Add Package Dependencies…** e informe a URL do repositório:

```text
https://github.com/muhittincamdali/mobile-design-patterns.git
```

**2. Importe o módulo**

```swift
import MobilePatterns
```

**3. Use**

Um view model que carrega artigos por meio de um repository e expõe um único estado de view. Uma atualização mantém a lista atual na tela, e uma atualização que falha também a mantém:

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

A view lê `state.value` para a lista, `state.isLoading` para o indicador de progresso e `state.failure` para o banner de erro.

## Instalação

### Swift Package Manager

No Xcode, escolha **File › Add Package Dependencies…** e informe a URL do repositório:

```text
https://github.com/muhittincamdali/mobile-design-patterns.git
```

Ou adicione-o às `dependencies` do seu `Package.swift`:

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

### Flutter e React Native

Os ports não são publicados no pub.dev nem no npm. Copie `ports/flutter` ou `ports/react-native` para o seu projeto, ou dependa da pasta por caminho; o [ports/README.md](ports/README.md) mostra as duas formas.

## Uso

Todos os exemplos abaixo foram copiados de [`ReadmeSamples.swift`](Examples/PatternGallery/PatternGallery/ReadmeSamples.swift), que o app de exemplo compila e os testes do pacote executam.

### Recusar um segundo toque com uma máquina de estados

As transições são um único `switch`. Enquanto a máquina está em `.paying`, `.pay` não é permitido, então um toque duplo cobra uma só vez:

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

### Abrir deep links por meio de um router

O `DeepLinkParser` verifica o scheme, o host, as credenciais, os segmentos `.` e `..`, uma `/` ou `\` codificada dentro de um segmento (`%2F`, `%5C`), a codificação, os caracteres de controle e os tamanhos antes de comparar com um padrão. Um padrão devolve a pilha inteira, então o botão de voltar funciona:

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

No app, `NavigationStack(path: $router.path)` mostra a pilha e `.onOpenURL { router.open($0) }` a alimenta.

### Adicionar tentativas repetidas, limite de tempo e compartilhamento de requisições com decorators

O `RequestBuilder` codifica o caminho e a query e recusa cabeçalhos inseguros; o `AsyncLoader` adiciona comportamento em camadas, de fora para dentro:

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

### Desfazer edições com commands

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

### Encapsular um SDK baseado em callbacks

O `withCompletion` guarda o primeiro resultado, ignora os callbacks seguintes e devolve `CancellationError` assim que a tarefa é cancelada:

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

### Enviar eventos para vários ouvintes

Cada stream de `Broadcaster.events()` recebe todos os eventos posteriores, com seu próprio buffer limitado:

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

Dê a cada ouvinte o seu próprio stream (`badge.listen(to: cartEvents.events())`) e chame `cartEvents.send(.added(itemID: 7))` em qualquer ponto em que o carrinho mudar.

## Demonstração

Telas do app de exemplo em um simulador de iPhone, capturadas por [`scripts/capture-screens.sh`](scripts/capture-screens.sh):

| Estado de view | Máquina de estados | Command e desfazer | Observer | Deep links |
| --- | --- | --- | --- | --- |
| ![Estado de view, claro](docs/images/articles-light.png) | ![Máquina de estados, claro](docs/images/checkout-light.png) | ![Command e desfazer, claro](docs/images/editor-light.png) | ![Observer, claro](docs/images/cart-light.png) | ![Deep links, claro](docs/images/links-light.png) |
| ![Estado de view, escuro](docs/images/articles-dark.png) | ![Máquina de estados, escuro](docs/images/checkout-dark.png) | ![Command e desfazer, escuro](docs/images/editor-dark.png) | ![Observer, escuro](docs/images/cart-dark.png) | ![Deep links, escuro](docs/images/links-dark.png) |

Para experimentar os padrões por conta própria, abra `PatternGallery.xcodeproj` em [`Examples/PatternGallery`](Examples/PatternGallery) com o Xcode, escolha um simulador de iPhone ou **My Mac** e pressione **Run**. O [Examples/README.md](Examples/README.md) também mostra como abrir um deep link no app em execução.

## Documentação

Referência da API e artigos:

- [Referência da API](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/)
  (DocC, publicada no GitHub Pages a partir de `main`)
- Gere-a localmente no Xcode com **Product › Build Documentation**, ou pela linha de comando:

```sh
xcodebuild docbuild -scheme MobilePatterns -destination 'generic/platform=macOS'
```

## Guias

- [Getting Started](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/gettingstarted)
  — adicionar o pacote, trocar as flags de carregamento por um único valor, conduzir a navegação a partir de um router
  ([código-fonte](Sources/MobilePatterns/MobilePatterns.docc/GettingStarted.md)).
- [Choosing a Pattern](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/choosingapattern)
  — de um sintoma no seu código ao tipo que o resolve, e quando não adicionar nenhum
  ([código-fonte](Sources/MobilePatterns/MobilePatterns.docc/ChoosingAPattern.md)).
- [Loading Data with View State](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/loadingdatawithviewstate)
  — políticas de cache por chamada, desenho de cada estado, atualizações do tipo cache primeiro, dados novos depois
  ([código-fonte](Sources/MobilePatterns/MobilePatterns.docc/LoadingDataWithViewState.md)).
- [Opening Deep Links Safely](https://muhittincamdali.github.io/mobile-design-patterns/documentation/mobilepatterns/openingdeeplinkssafely)
  — as verificações do parser em ordem, pilhas em vez de telas avulsas, erros que não repetem a entrada
  ([código-fonte](Sources/MobilePatterns/MobilePatterns.docc/OpeningDeepLinksSafely.md)).
- [Ports para Flutter e React Native](ports/README.md) — quais padrões foram portados e como executar os testes deles.

## Requisitos

| Plataforma | Versão mínima |
| --- | --- |
| iOS | 17 |
| macOS | 14 |
| Ferramentas | Swift 6.2 · Xcode 26+ |
| Port Flutter | Flutter 3.41 · Dart 3.11 |
| Port React Native | React 19 · Node 22.22 para os testes |

## Arquitetura

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

Decisões de projeto:

- **Tipos de valor onde o estado é local** (`Loadable`, `StateMachine`, `UndoStack`, `RequestBuilder`), um **actor** onde os chamadores compartilham estado (`Repository`) e um lock onde é preciso uma API síncrona a partir de qualquer thread (`Broadcaster`, `withCompletion`).
- **Limitado por padrão.** A profundidade do router, a capacidade do repository, o histórico de desfazer, os buffers do broadcaster e os tamanhos dos deep links têm limites; valores abaixo do mínimo são elevados a ele, em vez de derrubar o app.
- **Entradas externas são verificadas antes do uso.** Deep links e partes de requisições são validados, e os erros não carregam cópia da entrada rejeitada.
- **O README não fica desatualizado.** Os exemplos ficam em um arquivo Swift que o app de exemplo compila e os testes executam.

## Roteiro

- Adicionar o pacote ao Swift Package Index depois do lançamento da 2.0.0; o `.spi.yml` já está no repositório.
- Portar o `DeepLinkParser` para Dart e TypeScript, onde as mesmas verificações valem para links do `go_router` e do React Navigation.
- Um debouncer para campos de busca, com um relógio de teste.

## Como contribuir

Contribuições são bem-vindas. Leia o [guia de contribuição](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/CONTRIBUTING.md) e o [código de conduta](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/CODE_OF_CONDUCT.md) antes de abrir um pull request. Relate problemas de segurança de forma privada, como descrito na [política de segurança](https://github.com/muhittincamdali/mobile-design-patterns/blob/main/SECURITY.md).

## Licença

Publicado sob a licença MIT. Veja [LICENSE](LICENSE).
