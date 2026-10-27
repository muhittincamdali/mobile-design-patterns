# Flutter and React Native ports

Three of the Swift patterns carry over to Dart and TypeScript without losing anything, and they
are the ones a cross-platform team most often rewrites by hand: view state, the state machine
and undoable commands. Each port is a small package with its own tests, checked by CI next to
the Swift package. The patterns that depend on Swift concurrency or SwiftUI (`Repository`,
`AsyncLoader`, `withCompletion`, `Broadcaster`, `Router`) stay Swift only; Dart streams and
`go_router`, and React Navigation, already cover that ground on their platforms.

| Pattern          | Swift                      | Flutter (`ports/flutter`)                                  | React Native (`ports/react-native`) |
| ---------------- | -------------------------- | ---------------------------------------------------------- | ----------------------------------- |
| View state       | `Loadable`                 | `Loadable` sealed class                                    | `Loadable` union type               |
| MVVM view model  | `@Observable` model        | `LoadableController` (`ChangeNotifier`) and `LoadableView` | `useLoadable` hook                  |
| State            | `StateMachine`             | `StateMachine`                                             | `StateMachine`                      |
| Command and undo | `UndoStack`, `EditCommand` | `UndoStack`, `EditCommand`                                 | `UndoStack`, `EditCommand`          |

The controller and the hook add what the platform needs: only the newest load may change the
state, so a slow first request cannot overwrite a refresh, and results that arrive after the
screen is gone are dropped.

## Flutter

Flutter 3.41 or later (CI uses 3.47.5), Dart 3.11 or later.

```sh
cd ports/flutter
flutter pub get
flutter test
```

```dart
final controller = LoadableController(() => api.fetchArticles());

LoadableView<List<Article>>(
  controller: controller,
  loading: (_) => const CircularProgressIndicator(),
  failed: (_, error) => Text('Could not load: $error'),
  loaded: (_, articles, {required isRefreshing, error}) => ArticleList(
    articles,
    showsProgress: isRefreshing,
    banner: error == null ? null : 'Refresh failed',
  ),
);
```

## React Native

Node 22.22 or later, React 19. The package has no React Native dependency, so the same code
runs in React Native and in React on the web.

```sh
cd ports/react-native
npm ci
npm test
```

```tsx
function ArticlesScreen() {
    const { state, reload } = useLoadable(fetchArticles);
    useEffect(() => void reload(), [reload]);

    const articles = valueOf(state) ?? [];
    return (
        <FlatList
            data={articles}
            refreshing={state.status === "loading"}
            onRefresh={reload}
            renderItem={({ item }) => <ArticleRow article={item} />}
        />
    );
}
```
