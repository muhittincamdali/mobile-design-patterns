# Coordinator Pattern

> Separate navigation logic from view controllers

## Problem

- ViewControllers tightly coupled through segues
- Navigation logic scattered across views
- Hard to change navigation flow
- Deep links require access to navigation hierarchy

## Solution

```swift
// MARK: - Coordinator Protocol
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get }
    
    func start()
    func finish()
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
    }
    
    func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}

// MARK: - App Coordinator (Root)
class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    let window: UIWindow
    
    private let authService: AuthService
    
    init(window: UIWindow, authService: AuthService) {
        self.window = window
        self.authService = authService
        self.navigationController = UINavigationController()
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        if authService.isAuthenticated {
            showMainFlow()
        } else {
            showAuthFlow()
        }
    }
    
    private func showAuthFlow() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.delegate = self
        addChild(authCoordinator)
        authCoordinator.start()
    }
    
    private func showMainFlow() {
        let mainCoordinator = MainTabCoordinator(navigationController: navigationController)
        addChild(mainCoordinator)
        mainCoordinator.start()
    }
}

extension AppCoordinator: AuthCoordinatorDelegate {
    func authCoordinatorDidFinish(_ coordinator: AuthCoordinator) {
        removeChild(coordinator)
        showMainFlow()
    }
}

// MARK: - Auth Coordinator
protocol AuthCoordinatorDelegate: AnyObject {
    func authCoordinatorDidFinish(_ coordinator: AuthCoordinator)
}

class AuthCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    weak var delegate: AuthCoordinatorDelegate?
    
    private let authService: AuthService
    
    init(navigationController: UINavigationController, authService: AuthService = .shared) {
        self.navigationController = navigationController
        self.authService = authService
    }
    
    func start() {
        showLogin()
    }
    
    private func showLogin() {
        let viewModel = LoginViewModel(authService: authService)
        viewModel.onLoginSuccess = { [weak self] in
            self?.delegate?.authCoordinatorDidFinish(self!)
        }
        viewModel.onSignUpTapped = { [weak self] in
            self?.showSignUp()
        }
        viewModel.onForgotPasswordTapped = { [weak self] in
            self?.showForgotPassword()
        }
        
        let loginVC = LoginViewController(viewModel: viewModel)
        navigationController.setViewControllers([loginVC], animated: true)
    }
    
    private func showSignUp() {
        let viewModel = SignUpViewModel(authService: authService)
        viewModel.onSignUpSuccess = { [weak self] in
            self?.delegate?.authCoordinatorDidFinish(self!)
        }
        viewModel.onBackTapped = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        
        let signUpVC = SignUpViewController(viewModel: viewModel)
        navigationController.pushViewController(signUpVC, animated: true)
    }
    
    private func showForgotPassword() {
        let viewModel = ForgotPasswordViewModel()
        viewModel.onDismiss = { [weak self] in
            self?.navigationController.dismiss(animated: true)
        }
        
        let forgotVC = ForgotPasswordViewController(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: forgotVC)
        navigationController.present(nav, animated: true)
    }
}

// MARK: - Tab Coordinator
class MainTabCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    private let tabBarController = UITabBarController()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeCoordinator = HomeCoordinator()
        homeCoordinator.start()
        addChild(homeCoordinator)
        
        let searchCoordinator = SearchCoordinator()
        searchCoordinator.start()
        addChild(searchCoordinator)
        
        let profileCoordinator = ProfileCoordinator()
        profileCoordinator.start()
        addChild(profileCoordinator)
        
        tabBarController.viewControllers = [
            homeCoordinator.navigationController,
            searchCoordinator.navigationController,
            profileCoordinator.navigationController
        ]
        
        navigationController.setViewControllers([tabBarController], animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}

// MARK: - Deep Link Handling
enum DeepLink {
    case profile(userId: String)
    case post(postId: String)
    case settings
    case checkout(productId: String)
}

extension AppCoordinator {
    func handle(deepLink: DeepLink) {
        switch deepLink {
        case .profile(let userId):
            if let mainCoordinator = childCoordinators.first(where: { $0 is MainTabCoordinator }) as? MainTabCoordinator {
                mainCoordinator.showProfile(userId: userId)
            }
            
        case .post(let postId):
            if let mainCoordinator = childCoordinators.first(where: { $0 is MainTabCoordinator }) as? MainTabCoordinator {
                mainCoordinator.showPost(postId: postId)
            }
            
        case .settings:
            if let mainCoordinator = childCoordinators.first(where: { $0 is MainTabCoordinator }) as? MainTabCoordinator {
                mainCoordinator.showSettings()
            }
            
        case .checkout(let productId):
            let checkoutCoordinator = CheckoutCoordinator(
                navigationController: navigationController,
                productId: productId
            )
            addChild(checkoutCoordinator)
            checkoutCoordinator.start()
        }
    }
}
```

## SwiftUI Router

```swift
class Router: ObservableObject {
    @Published var path = NavigationPath()
    @Published var presentedSheet: Sheet?
    @Published var presentedFullScreen: Sheet?
    
    enum Route: Hashable {
        case profile(userId: String)
        case postDetail(postId: String)
        case settings
        case editProfile
    }
    
    enum Sheet: Identifiable {
        case createPost
        case imagePreview(URL)
        case share(items: [Any])
        
        var id: String {
            switch self {
            case .createPost: return "createPost"
            case .imagePreview: return "imagePreview"
            case .share: return "share"
            }
        }
    }
    
    func navigate(to route: Route) {
        path.append(route)
    }
    
    func present(_ sheet: Sheet) {
        presentedSheet = sheet
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    func dismiss() {
        presentedSheet = nil
        presentedFullScreen = nil
    }
}

struct ContentView: View {
    @StateObject private var router = Router()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView()
                .navigationDestination(for: Router.Route.self) { route in
                    switch route {
                    case .profile(let userId):
                        ProfileView(userId: userId)
                    case .postDetail(let postId):
                        PostDetailView(postId: postId)
                    case .settings:
                        SettingsView()
                    case .editProfile:
                        EditProfileView()
                    }
                }
        }
        .sheet(item: $router.presentedSheet) { sheet in
            switch sheet {
            case .createPost:
                CreatePostView()
            case .imagePreview(let url):
                ImagePreviewView(url: url)
            case .share(let items):
                ShareSheet(items: items)
            }
        }
        .environmentObject(router)
    }
}
```

## When to Use ✅

- Complex navigation flows
- Deep linking support needed
- A/B testing navigation
- Multiple entry points to screens
- Reusable flows (auth, checkout)

## When NOT to Use ❌

- Simple linear navigation
- Few screens
- No deep linking requirements

## Related Patterns

- **Mediator**: Coordinates communication
- **Command**: For navigation actions
- **State**: Track navigation state
