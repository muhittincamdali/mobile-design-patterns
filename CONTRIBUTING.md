# Contributing

Thanks for helping. This repository holds a Swift package (`Sources/`, `Tests/`), an example app
(`Examples/PatternGallery`) and two ports (`ports/flutter`, `ports/react-native`).

## What fits

A pattern belongs here when it removes a real bug or a repeated decision from app code, and
when it can be tested without a device. A change to an existing type is welcome when it comes
with a test that fails before the change.

Open an issue first for a new pattern or a change to public API, so the shape can be agreed
before you write it.

## Set up

```sh
git clone https://github.com/muhittincamdali/mobile-design-patterns.git
cd mobile-design-patterns
swift test
```

Xcode 26 or later. For the example app, open `Examples/PatternGallery/PatternGallery.xcodeproj`.
The project file is made with [XcodeGen](https://github.com/yonaskolb/XcodeGen) from
`Examples/PatternGallery/project.yml`; run `xcodegen` in that folder after editing it.

For the ports:

```sh
cd ports/flutter && flutter pub get && flutter analyze && flutter test
cd ports/react-native && npm ci && npm run typecheck && npm test
```

## Rules for code

- Swift 6 language mode, no warnings, no dependencies.
- Every public declaration has a documentation comment that says what it does with edge
  cases: limits, cancellation, invalid input.
- Anything that can grow (stacks, caches, buffers, histories) has a limit. Out-of-range
  arguments are clamped or refused with an error; they do not trap.
- Input from outside the app (URLs, headers, server data) is checked before use, and error
  values do not carry copies of rejected input.
- Tests use Swift Testing. Concurrency tests hold work with a gate and wait on a condition
  rather than sleeping, so they do not depend on timing.

## README samples

The README's code comes from `Examples/PatternGallery/PatternGallery/ReadmeSamples.swift`. The
test target compiles that file through a symlink, so change the sample there, add or update a
test in `Tests/MobilePatternsTests/ReadmeSampleTests.swift`, then copy it into the README.

## Screenshots

`scripts/capture-screens.sh` rebuilds the example app on an iPhone simulator and replaces the
images in `docs/images/`. Run it when a screen changes.

## Commits and pull requests

Use [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `docs:`,
`test:`, `ci:`, `chore:`), one logical change per commit, and add a line to `CHANGELOG.md`
under Unreleased. By contributing you agree that your work is released under the MIT license.
