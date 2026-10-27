import Observation

/// The navigation stack of one `NavigationStack`, owned outside the views: the *coordinator*
/// pattern for SwiftUI.
///
/// Views ask the router to move instead of holding `NavigationLink` destinations themselves, so
/// a deep link, a push notification or a test can drive navigation the same way a tap does.
///
/// ```swift
/// @State private var router = Router<AppRoute>()
///
/// NavigationStack(path: $router.path) {
///     HomeView()
///         .navigationDestination(for: AppRoute.self) { route in destination(for: route) }
/// }
/// .environment(router)
/// ```
///
/// The stack has a depth limit, so a malformed deep link or a push in a loop cannot grow it
/// without bound. The limit also holds for writes to ``path`` itself, which is where the
/// `NavigationStack` binding and `NavigationLink(value:)` push.
@MainActor
@Observable
public final class Router<Route: Hashable> {
    /// The routes above the root view, bottom first. Bind it to `NavigationStack(path:)`.
    ///
    /// A stack deeper than ``maxDepth`` written here is cut to its first ``maxDepth`` routes, so
    /// a push past the limit through the binding is undone instead of growing the stack.
    public var path: [Route] {
        didSet {
            if path.count > maxDepth { path = Array(path.prefix(maxDepth)) }
        }
    }

    /// The most routes ``path`` may hold. ``push(_:)`` and ``replaceStack(with:)`` refuse to go
    /// beyond it, and writes to ``path`` are cut to it.
    public let maxDepth: Int

    /// Creates a router.
    ///
    /// - Parameters:
    ///   - path: The initial stack. Routes beyond `maxDepth` are dropped.
    ///   - maxDepth: The deepest stack allowed. Values below 1 are treated as 1.
    public init(path: [Route] = [], maxDepth: Int = 32) {
        let depth = max(1, maxDepth)
        self.maxDepth = depth
        self.path = Array(path.prefix(depth))
    }

    /// The route on top of the stack, or `nil` at the root.
    public var top: Route? { path.last }

    /// Pushes `route`. Returns `false` and changes nothing when the stack is at ``maxDepth``.
    @discardableResult
    public func push(_ route: Route) -> Bool {
        guard path.count < maxDepth else { return false }
        path.append(route)
        return true
    }

    /// Pops `count` routes, or every route when fewer are on the stack. A count of zero or less
    /// does nothing.
    public func pop(_ count: Int = 1) {
        guard count > 0 else { return }
        path.removeLast(min(count, path.count))
    }

    /// Returns to the root view.
    public func popToRoot() {
        path.removeAll()
    }

    /// Pops back to the topmost occurrence of `route`. Returns `false` and changes nothing when
    /// `route` is not on the stack.
    @discardableResult
    public func pop(to route: Route) -> Bool {
        guard let index = path.lastIndex(of: route) else { return false }
        path.removeSubrange(path.index(after: index)...)
        return true
    }

    /// Replaces the whole stack, for example with the routes of a deep link. Returns `false` and
    /// changes nothing when `routes` is deeper than ``maxDepth``.
    @discardableResult
    public func replaceStack(with routes: [Route]) -> Bool {
        guard routes.count <= maxDepth else { return false }
        path = routes
        return true
    }
}
