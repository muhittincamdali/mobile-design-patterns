# `MobilePatterns`

Design patterns for iOS and macOS apps as small, tested Swift types: view state, state machine, coordinator and deep links, repository, decorators, adapter, observer, command and builder.

## Overview

MobilePatterns is a Swift package with no dependencies for iOS 17 and macOS 14. Each pattern is
one type you can use on its own, written for Swift 6 strict concurrency, and each one handles
the cases that a textbook version skips: a second tap while a payment runs, a completion
handler that is called twice, a deep link with `..` in it, a subscriber that stops reading.

```swift
import MobilePatterns

@MainActor
@Observable
final class ArticleListModel {
    private(set) var state: Loadable<[Article], ArticleError> = .idle
    private let repository: Repository<String, [Article]>

    init(client: ArticleClient) {
        repository = Repository(capacity: 1, timeToLive: .seconds(300)) { _ in try await client.list() }
    }

    func refresh() async {
        state.startLoading()   // keeps the current list on screen
        do {
            state.finish(with: .success(try await repository.value(for: "articles", policy: .reloadIgnoringCache)))
        } catch {
            state.finish(with: .failure(error as? ArticleError ?? .offline))
        }
    }
}
```

| Pattern                 | Type                          |
| ----------------------- | ----------------------------- |
| View state              | ``Loadable``                    |
| State                   | ``StateMachine``                |
| Coordinator             | ``Router``, ``DeepLinkParser``    |
| Repository and strategy | ``Repository``, ``CachePolicy``   |
| Decorator and proxy     | ``AsyncLoader``                 |
| Adapter                 | ``withCompletion(onCancel:_:)`` |
| Observer                | ``Broadcaster``                 |
| Command and memento     | ``UndoStack``, ``EditCommand``    |
| Builder                 | ``RequestBuilder``              |

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:ChoosingAPattern>
- <doc:LoadingDataWithViewState>
- <doc:OpeningDeepLinksSafely>

### State

- ``Loadable``
- ``StateMachine``

### Navigation

- ``Router``
- ``DeepLinkParser``
- ``DeepLinkParameters``
- ``DeepLinkError``

### Data

- ``Repository``
- ``CachePolicy``
- ``RepositoryError``
- ``AsyncLoader``
- ``AsyncLoaderTimeoutError``

### Concurrency

- ``withCompletion(onCancel:_:)``
- ``Broadcaster``

### Editing

- ``UndoStack``
- ``EditCommand``

### Networking

- ``RequestBuilder``
- ``RequestBuilderError``
