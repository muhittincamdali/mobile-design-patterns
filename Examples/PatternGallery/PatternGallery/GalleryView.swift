import MobilePatterns
import SwiftUI

/// The root screen. Navigation goes through one `Router`, so taps, deep links
/// (`patterns://articles/2`) and launch arguments all use the same path.
struct GalleryView: View {
    @State private var router: Router<AppRoute>
    private let link: URL?

    init(initialPath: [AppRoute] = [], link: URL? = nil) {
        _router = State(initialValue: Router(path: initialPath))
        self.link = link
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            List {
                Section("State") {
                    entry(.articles, "View state, MVVM and repository", "Loadable keeps the list during a refresh", "arrow.triangle.2.circlepath")
                    entry(.checkout, "State machine", "A second tap on Pay is refused", "point.3.connected.trianglepath.dotted")
                }
                Section("Behaviour") {
                    entry(.editor, "Command and undo", "Every edit can be taken back", "arrow.uturn.backward")
                    entry(.cart, "Observer", "Two subscribers, one broadcaster", "dot.radiowaves.left.and.right")
                }
                Section("Navigation") {
                    entry(.links, "Coordinator and deep links", "Checked links replace the stack", "link")
                }
            }
            .navigationTitle("Pattern Gallery")
            .navigationDestination(for: AppRoute.self, destination: destination)
        }
        .environment(router)
        .onOpenURL { router.open($0) }
        .task {
            if let link { router.open(link) }
        }
    }

    private func entry(_ route: AppRoute, _ title: String, _ detail: String, _ symbol: String) -> some View {
        NavigationLink(value: route) {
            Label {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                    Text(detail).font(.footnote).foregroundStyle(.secondary)
                }
            } icon: {
                Image(systemName: symbol).foregroundStyle(.blue)
            }
        }
    }

    @ViewBuilder
    private func destination(_ route: AppRoute) -> some View {
        switch route {
        case .articles: ArticlesScreen()
        case .article(let id): ArticleDetailScreen(id: id)
        case .checkout: CheckoutScreen()
        case .editor: NotesScreen()
        case .links: DeepLinksScreen()
        case .cart: CartScreen()
        }
    }
}
