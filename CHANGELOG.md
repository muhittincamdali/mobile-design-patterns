# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.0] - 2026-10-28

The repository becomes a tested Swift package with an example app and Flutter and React Native
ports. Version 1.0.0 was documentation only, and its code samples did not compile; those pages
were removed, so this is a major version.

### Added

- `MobilePatterns`, a Swift package for iOS 17+ and macOS 14+ with no dependencies, built in the
  Swift 6 language mode:
    - `Loadable`: view state that keeps the previous value through a reload or a failure.
    - `StateMachine`: transitions as one closure; refused events keep the state.
    - `Router`: an `@Observable` navigation stack with a depth limit.
    - `DeepLinkParser`, `DeepLinkParameters`, `DeepLinkError`: allowlisted schemes and hosts, no
      credentials, no `.` or `..` segments, no `/` or `\` encoded inside a segment (`%2F`, `%5C`),
      valid percent encoding, no control characters, size limits, and patterns that return the
      whole stack. Errors name the failed check and at most a position, never text from the URL.
    - `Repository` and `CachePolicy`: an actor with a bounded LRU cache, time to live, shared
      fetches per key, cached-then-fresh updates, and overtaken fetches that are not stored.
    - `AsyncLoader`: `retrying` (1 to 100 attempts), `timeout` and `coalescing` decorators.
    - `withCompletion(onCancel:_:)`: callback-to-async adapter that ignores duplicate callbacks
      and returns at once on cancellation.
    - `Broadcaster`: one event stream per subscriber with a bounded buffer.
    - `UndoStack` and `EditCommand`: undo and redo with a history limit.
    - `RequestBuilder`: URL requests with encoded paths and queries, no `.` or `..` segment or
      part of a segment (such as `../admin`), header injection checks, no body on `GET` or
      `HEAD`, and positive timeouts. Errors carry no text from the request, not even a header
      name.
- 103 Swift Testing tests, including the README samples and a live client against a stubbed
  `URLSession`.
- `PatternGallery`, an iOS and macOS example app with one screen per pattern and a `patterns://`
  URL scheme.
- DocC catalog with four articles: Getting Started, Choosing a Pattern, Loading Data with View
  State, Opening Deep Links Safely.
- `ports/flutter`: `Loadable`, `LoadableController`, `LoadableView`, `StateMachine` and
  `UndoStack`, with 11 tests.
- `ports/react-native`: `Loadable`, `useLoadable`, `StateMachine` and `UndoStack` in TypeScript,
  with 17 tests.
- `scripts/capture-screens.sh`, which captures the README screenshots from the example app.
- CI for the package (macOS and iPhone simulator), the example app, both ports, the
  documentation site, links, wording and README translations.

### Removed

- The Markdown pattern guides and the uncompiled Swift and Kotlin example files.
- The scaffolding script, the stale-bot configuration and the Markdown-only CI workflow.

## [1.0.0] - 2026-02-03

### Added

- Markdown guides for creational, structural, behavioral and architectural patterns, with Swift,
  Kotlin, Dart and TypeScript snippets.

[Unreleased]: https://github.com/muhittincamdali/mobile-design-patterns/compare/v2.0.0...HEAD
[2.0.0]: https://github.com/muhittincamdali/mobile-design-patterns/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/muhittincamdali/mobile-design-patterns/releases/tag/v1.0.0
