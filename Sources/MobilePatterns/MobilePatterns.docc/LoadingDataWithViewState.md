# Loading data with view state

Combine ``Loadable``, ``Repository`` and an `@Observable` model so a screen loads once, refreshes
without flashing, and survives a failed refresh.

## Overview

The model owns a ``Repository`` and exposes a ``Loadable``. The repository decides where a
value comes from; the ``Loadable`` tells the view what to draw.

### Pick a cache policy per call

``CachePolicy`` is chosen by the caller, not by the repository:

| Call                                       | Policy                            | Behaviour                            |
| ------------------------------------------ | --------------------------------- | ------------------------------------ |
| First appearance of the screen             | ``CachePolicy/cacheFirst``          | Fresh cached value, or fetch         |
| Pull to refresh                            | ``CachePolicy/reloadIgnoringCache`` | Always fetch, store the result       |
| Screen that must work offline              | ``CachePolicy/networkFirst``        | Fetch, fall back to any cached value |
| Widget or extension with no network budget | ``CachePolicy/cacheOnly``           | Never fetch                          |

```swift
func load() async { await load(policy: .cacheFirst) }
func refresh() async { await load(policy: .reloadIgnoringCache) }

private func load(policy: CachePolicy) async {
    state.startLoading()
    do {
        state.finish(with: .success(try await repository.value(for: "articles", policy: policy)))
    } catch {
        state.finish(with: .failure(error as? ArticleError ?? .offline))
    }
}
```

### Draw every state from one value

```swift
List {
    if let failure = model.state.failure {
        Label("Refresh failed: \(failure)", systemImage: "wifi.exclamationmark")
    }
    ForEach(model.state.value ?? []) { article in
        ArticleRow(article)
    }
}
.overlay { if model.state.isLoading && model.state.value == nil { ProgressView() } }
.refreshable { await model.refresh() }
.task { await model.load() }
```

After a failed refresh the state is `.failed(error, previous: articles)`: the list stays and
the banner appears. The next refresh moves to `.loading(previous: articles)`, so the list still
stays.

### Show cached data first, then fresh data

``Repository/updates(for:)`` yields the cached value at once, even an expired one, and then
the fetched value. It suits a detail screen opened from a list:

```swift
.task {
    do {
        for try await article in repository.updates(for: id) { self.article = article }
    } catch {
        showsBanner = true
    }
}
```

### Things the repository handles for you

- Two screens asking for the same key at once share one fetch.
- A fetch that was overtaken by ``Repository/store(_:for:)`` or ``Repository/invalidate(_:)``
  is returned to its caller but not stored, so a local edit is not overwritten by an older
  server answer.
- The cache holds at most `capacity` entries and drops the least recently used one.
- A fetch runs to its end even when the caller that started it was cancelled, so the other
  callers still get the value and it is cached.

## See Also

- ``Loadable``
- ``Repository``
- ``AsyncLoader``
