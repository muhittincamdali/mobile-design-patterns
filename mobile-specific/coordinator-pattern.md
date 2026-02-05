# Coordinator Pattern for Mobile

> Centralized navigation management for iOS apps

## Problem

Navigation spaghetti in mobile apps:
- ViewControllers know about each other
- Hard to reuse screens in different flows
- Deep linking is a nightmare
- A/B testing navigation is complex

## Solution

```swift
// MARK: - Coordinator Protocol
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get }
    func start()
}

// MARK: - Main App Coordinator
class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        if UserSession.isLoggedIn {
            showMainApp()
        } else {
            showOnboarding()
        }
    }
    
    private func showOnboarding() {
        let onboardingCoordinator = OnboardingCoordinator(
            navigationController: navigationController
        )
        onboardingCoordinator.delegate = self
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    private func showMainApp() {
        let mainCoordinator = MainTabCoordinator(
            navigationController: navigationController
        )
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }
}

extension AppCoordinator: OnboardingCoordinatorDelegate {
    func didFinishOnboarding() {
        childCoordinators.removeAll { $0 is OnboardingCoordinator }
        showMainApp()
    }
}

// MARK: - Feature Coordinator
class CheckoutCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    private let cart: Cart
    
    init(navigationController: UINavigationController, cart: Cart) {
        self.navigationController = navigationController
        self.cart = cart
    }
    
    func start() {
        showCart()
    }
    
    func showCart() {
        let vm = CartViewModel(cart: cart)
        vm.onCheckout = { [weak self] in
            self?.showShipping()
        }
        let vc = CartViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showShipping() {
        let vm = ShippingViewModel()
        vm.onContinue = { [weak self] address in
            self?.showPayment(address: address)
        }
        let vc = ShippingViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showPayment(address: Address) {
        let vm = PaymentViewModel(cart: cart, address: address)
        vm.onSuccess = { [weak self] order in
            self?.showConfirmation(order: order)
        }
        let vc = PaymentViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showConfirmation(order: Order) {
        let vc = OrderConfirmationViewController(order: order)
        vc.onDone = { [weak self] in
            self?.navigationController.popToRootViewController(animated: true)
        }
        navigationController.pushViewController(vc, animated: true)
    }
}
```

## SwiftUI Router

```swift
@MainActor
class AppRouter: ObservableObject {
    @Published var path = NavigationPath()
    @Published var sheet: Sheet?
    @Published var fullScreenCover: Sheet?
    
    enum Route: Hashable {
        case productDetail(id: String)
        case userProfile(id: String)
        case settings
        case checkout
    }
    
    enum Sheet: Identifiable {
        case cart
        case login
        case filter
        
        var id: String { String(describing: self) }
    }
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    func present(_ sheet: Sheet) {
        self.sheet = sheet
    }
    
    func dismiss() {
        sheet = nil
        fullScreenCover = nil
    }
}

struct RootView: View {
    @StateObject var router = AppRouter()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView()
                .navigationDestination(for: AppRouter.Route.self) { route in
                    destinationView(for: route)
                }
        }
        .sheet(item: $router.sheet) { sheet in
            sheetView(for: sheet)
        }
        .environmentObject(router)
    }
    
    @ViewBuilder
    func destinationView(for route: AppRouter.Route) -> some View {
        switch route {
        case .productDetail(let id):
            ProductDetailView(productId: id)
        case .userProfile(let id):
            UserProfileView(userId: id)
        case .settings:
            SettingsView()
        case .checkout:
            CheckoutView()
        }
    }
    
    @ViewBuilder
    func sheetView(for sheet: AppRouter.Sheet) -> some View {
        switch sheet {
        case .cart:
            CartView()
        case .login:
            LoginView()
        case .filter:
            FilterView()
        }
    }
}
```

## Deep Link Handling

```swift
extension AppCoordinator {
    func handle(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let host = components.host else {
            return
        }
        
        let pathComponents = components.path.split(separator: "/").map(String.init)
        
        switch host {
        case "product":
            if let productId = pathComponents.first {
                navigateToProduct(id: productId)
            }
        case "user":
            if let userId = pathComponents.first {
                navigateToUser(id: userId)
            }
        case "checkout":
            navigateToCheckout()
        default:
            break
        }
    }
    
    private func navigateToProduct(id: String) {
        // Find or create appropriate coordinator
        let productCoordinator = ProductCoordinator(
            navigationController: navigationController,
            productId: id
        )
        childCoordinators.append(productCoordinator)
        productCoordinator.start()
    }
}
```

## When to Use ✅

- Apps with multiple flows
- Need deep linking
- Screens reused in different contexts
- Complex navigation

## When NOT to Use ❌

- Simple 2-3 screen apps
- Purely declarative SwiftUI apps
- No deep linking needs
