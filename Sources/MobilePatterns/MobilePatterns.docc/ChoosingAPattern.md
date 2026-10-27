# Choosing a pattern

Start from the symptom in your code, not from the pattern catalogue.

## Overview

Patterns are worth their extra type only when they remove a bug or a duplicated decision.
The table maps common symptoms in iOS code to the type in this package that addresses them.

| Symptom                                                                               | Pattern          | Type                            |
| ------------------------------------------------------------------------------------- | ---------------- | ------------------------------- |
| A screen shows a spinner and an error at once, or loses its list while refreshing     | View state       | ``Loadable``                      |
| A double tap starts a second payment; flags such as `isPaying` and `didFail` disagree | State            | ``StateMachine``                  |
| Views build their own destinations, so a notification or a link cannot open a screen  | Coordinator      | ``Router``                        |
| A link from outside opens the wrong screen or crashes on a bad identifier             | Coordinator      | ``DeepLinkParser``                |
| Two screens fetch the same data; each one decides on its own when the cache is stale  | Repository       | ``Repository`` with ``CachePolicy`` |
| Retries, timeouts and request sharing are copied into every API call                  | Decorator, proxy | ``AsyncLoader``                   |
| A callback SDK crashes the app by calling back twice, or hangs a cancelled task       | Adapter          | ``withCompletion(onCancel:_:)``   |
| Several parts of the app need the same events (cart badge, analytics, sync)           | Observer         | ``Broadcaster``                   |
| Undo is missing, or it stores a full copy of the document per step                    | Command, memento | ``UndoStack``                     |
| URLs are built by string concatenation and break on `+`, `/` or line breaks           | Builder          | ``RequestBuilder``                |

### When not to add one

- A screen that loads once and never refreshes can use `task` and a plain optional.
- Two boolean flags with one obvious rule do not need a ``StateMachine``. Three states with
  rules about which may follow which do.
- An app with one `NavigationStack` and no deep links gains little from a ``Router``.
- A value read once per launch needs no ``Repository``; a value shown on several screens does.

### Combining them

The patterns compose without knowing about each other. The example app's article client
builds requests with ``RequestBuilder``, wraps the call in ``AsyncLoader`` decorators, stores
results in a ``Repository``, and exposes them to SwiftUI through an `@Observable` model that
holds a ``Loadable``:

```swift
let article = AsyncLoader<Int, Article> { id in try await get(api.path("articles", String(id))) }
    .timeout(.seconds(10))
    .retrying(maxAttempts: 3, delay: .milliseconds(300))
    .coalescing()
```

Decorators run from the outside in: above, two screens asking for the same article share one
retried request, and each attempt has its own ten-second limit.

## See Also

- <doc:GettingStarted>
- <doc:LoadingDataWithViewState>
- <doc:OpeningDeepLinksSafely>
