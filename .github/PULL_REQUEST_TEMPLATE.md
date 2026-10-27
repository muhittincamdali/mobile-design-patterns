## What and why

<!-- What changes, and the problem it solves. Link the issue if there is one. -->

## Checks

- [ ] `swift build` and `swift test` pass, with no new warnings
- [ ] New behaviour has tests, including the edge cases (cancellation, limits, invalid input)
- [ ] Public API has documentation comments; `xcodebuild docbuild -scheme MobilePatterns -destination 'generic/platform=macOS'` reports no warnings
- [ ] If a README sample changed, it was changed in `Examples/PatternGallery/PatternGallery/ReadmeSamples.swift`
- [ ] For the ports: `flutter analyze` and `flutter test` in `ports/flutter`, `npm test` in `ports/react-native`
- [ ] `CHANGELOG.md` has an entry under Unreleased
