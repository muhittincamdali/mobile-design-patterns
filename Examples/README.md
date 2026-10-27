# Examples

## PatternGallery

An iOS and macOS app with one screen per pattern of the `MobilePatterns` package:

| Screen           | Patterns                                                                |
| ---------------- | ----------------------------------------------------------------------- |
| View state       | `Loadable`, MVVM (`ArticleListModel`), `Repository` with a cache policy |
| State machine    | `StateMachine` driving a checkout; a second tap on Pay is refused       |
| Command and undo | `UndoStack` and `EditCommand` with named undo and redo                  |
| Observer         | `Broadcaster` with two subscribers                                      |
| Deep links       | `Router` and `DeepLinkParser`, with links that are accepted and refused |

It uses the package from this checkout (a local package reference to `../..`), so it always
shows the current code.

Run it:

1. Open `Examples/PatternGallery/PatternGallery.xcodeproj` in Xcode 26 or later.
2. Choose the **PatternGallery** scheme and an iPhone simulator or **My Mac** as the run
   destination.
3. Press **Run** (⌘R).

From the command line:

```sh
cd Examples/PatternGallery
xcodebuild build -scheme PatternGallery -destination 'generic/platform=iOS Simulator'
xcodebuild build -scheme PatternGallery -destination 'platform=macOS'
```

Open a deep link in the running app on a simulator (iOS asks once whether to open the app):

```sh
xcrun simctl openurl booted "patterns://articles/2"
```

Or pass it at launch, which goes through the same `Router.open(_:)` call without the prompt:

```sh
xcrun simctl launch booted io.github.muhittincamdali.PatternGallery -link "patterns://articles/2"
```

The README samples live in
[`PatternGallery/ReadmeSamples.swift`](PatternGallery/PatternGallery/ReadmeSamples.swift). The
package's test target compiles and runs the same file through the symlink
`Tests/MobilePatternsTests/ReadmeSamples.swift`.

The README screenshots come from this app: `scripts/capture-screens.sh` builds it, opens each
screen with `-screen <name>` and saves light and dark simulator screenshots to `docs/images/`.

The project file is made with [XcodeGen](https://github.com/yonaskolb/XcodeGen) from
[`project.yml`](PatternGallery/project.yml) and committed, so you only need XcodeGen after
editing `project.yml`.
