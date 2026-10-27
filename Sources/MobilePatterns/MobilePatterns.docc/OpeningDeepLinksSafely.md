# Opening deep links safely

Check a URL before it changes navigation, and open the whole stack it points to.

## Overview

A deep link is input from outside the app. Anyone can put one in a message, a QR code or a web
page, so the app should treat it like any other untrusted input: accept only what it expects
and refuse the rest without crashing or opening a half-built screen.

``DeepLinkParser`` runs its checks in a fixed order and stops at the first failure:

1. Length of the whole URL (``DeepLinkParser/Limits/maxURLLength``, 2,048 bytes by default).
2. Scheme in the allowlist, compared without case.
3. No user name or password (`https://user@example.com/…`).
4. For `http` and `https`, the host in the allowlist. `example.com.evil.test` is a different
   host and is refused.
5. Segment count, then each segment: valid UTF-8 after percent decoding, not `.` or `..`
   (also when written as `%2E%2E`), no control characters, not longer than
   ``DeepLinkParser/Limits/maxValueLength``.
6. Query item count and the same checks for each name and value.
7. The first pattern whose segments match; its closure builds the stack or refuses it.

### Describe the links

```swift
let parser = DeepLinkParser<AppRoute>(
    schemes: ["https", "patterns"],
    hosts: ["example.com"],
    patterns: [
        .init("articles") { _ in [.articles] },
        .init("articles/:id") { parameters in
            parameters.int("id").map { [.articles, .article(id: $0)] }
        },
        .init("search") { parameters in
            parameters["q"].map { [.search($0)] }
        }
    ]
)
```

A pattern returns the whole stack, not only the last screen, so the back button leads where
the user expects. ``DeepLinkParameters/int(_:)`` accepts ASCII digits only and returns `nil`
for signs, other numerals and values that do not fit in `Int`, instead of trapping.

For custom schemes the host is read as the first path segment, so `patterns://articles/42`
and `https://example.com/articles/42` match the same pattern.

### Open the stack

```swift
.onOpenURL { url in
    guard let routes = try? parser.routes(for: url) else { return }
    router.replaceStack(with: routes)
}
```

``Router/replaceStack(with:)`` refuses stacks deeper than ``Router/maxDepth``, as a last
guard against a pattern that builds too many routes.

### Report refusals without echoing input

``DeepLinkError`` tells you which check failed. Values from the URL are not copied into it: a
bad path segment is reported as `"segment 3"`, and a bad query item by its name without control
characters, cut to 32 characters. That keeps log lines and analytics events from carrying
whatever text the link contained.

## See Also

- ``DeepLinkParser``
- ``Router``
- ``DeepLinkError``
