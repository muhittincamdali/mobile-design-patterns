# View State Pattern

> Single state object for UI state management

## Problem

- Multiple @Published properties for UI state
- Inconsistent state (loading=true AND error!=nil)
- State management scattered across ViewModel

## Solution

```swift
// MARK: - View State Enum
enum ViewState<T> {
    case idle
    case loading
    case loaded(T)
    case error(Error)
    
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    
    var data: T? {
        if case .loaded(let data) = self { return data }
        return nil
    }
    
    var error: Error? {
        if case .error(let error) = self { return error }
        return nil
    }
}

// MARK: - ViewModel with View State
class ProductListViewModel: ObservableObject {
    @Published var state: ViewState<[Product]> = .idle
    
    private let repository: ProductRepository
    
    init(repository: ProductRepository) {
        self.repository = repository
    }
    
    func loadProducts() async {
        state = .loading
        
        do {
            let products = try await repository.getProducts()
            state = .loaded(products)
        } catch {
            state = .error(error)
        }
    }
    
    func refresh() async {
        await loadProducts()
    }
}

// MARK: - View
struct ProductListView: View {
    @StateObject var viewModel: ProductListViewModel
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .idle:
                Color.clear.onAppear {
                    Task { await viewModel.loadProducts() }
                }
                
            case .loading:
                ProgressView("Loading products...")
                
            case .loaded(let products):
                List(products) { product in
                    ProductRow(product: product)
                }
                .refreshable {
                    await viewModel.refresh()
                }
                
            case .error(let error):
                ErrorView(error: error) {
                    Task { await viewModel.loadProducts() }
                }
            }
        }
        .navigationTitle("Products")
    }
}
```

## Advanced View State with Multiple Data

```swift
// MARK: - Composite View State
struct ProfileViewState {
    var user: ViewState<User> = .idle
    var posts: ViewState<[Post]> = .idle
    var followers: ViewState<[User]> = .idle
    
    var isFullyLoaded: Bool {
        user.data != nil && posts.data != nil && followers.data != nil
    }
    
    var hasAnyError: Bool {
        user.error != nil || posts.error != nil || followers.error != nil
    }
}

class ProfileViewModel: ObservableObject {
    @Published var state = ProfileViewState()
    
    private let userService: UserService
    private let postService: PostService
    
    init(userService: UserService, postService: PostService) {
        self.userService = userService
        self.postService = postService
    }
    
    func loadProfile(userId: String) async {
        // Load all data concurrently
        state.user = .loading
        state.posts = .loading
        state.followers = .loading
        
        async let userTask = userService.getUser(id: userId)
        async let postsTask = postService.getPosts(userId: userId)
        async let followersTask = userService.getFollowers(userId: userId)
        
        // Handle user
        do {
            let user = try await userTask
            state.user = .loaded(user)
        } catch {
            state.user = .error(error)
        }
        
        // Handle posts
        do {
            let posts = try await postsTask
            state.posts = .loaded(posts)
        } catch {
            state.posts = .error(error)
        }
        
        // Handle followers
        do {
            let followers = try await followersTask
            state.followers = .loaded(followers)
        } catch {
            state.followers = .error(error)
        }
    }
}

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    let userId: String
    
    var body: some View {
        ScrollView {
            VStack {
                userSection
                postsSection
                followersSection
            }
        }
        .task {
            await viewModel.loadProfile(userId: userId)
        }
    }
    
    @ViewBuilder
    var userSection: some View {
        switch viewModel.state.user {
        case .idle, .loading:
            ProfileHeaderSkeleton()
        case .loaded(let user):
            ProfileHeader(user: user)
        case .error:
            ErrorBanner(message: "Failed to load profile")
        }
    }
    
    @ViewBuilder
    var postsSection: some View {
        switch viewModel.state.posts {
        case .idle, .loading:
            PostsSkeleton()
        case .loaded(let posts):
            PostsGrid(posts: posts)
        case .error:
            ErrorBanner(message: "Failed to load posts")
        }
    }
    
    @ViewBuilder
    var followersSection: some View {
        switch viewModel.state.followers {
        case .idle, .loading:
            FollowersSkeleton()
        case .loaded(let followers):
            FollowersPreview(followers: followers)
        case .error:
            ErrorBanner(message: "Failed to load followers")
        }
    }
}
```

## Loadable Protocol

```swift
protocol Loadable {
    associatedtype Value
    var state: ViewState<Value> { get set }
    func load() async
}

extension Loadable {
    var isLoading: Bool { state.isLoading }
    var data: Value? { state.data }
    var error: Error? { state.error }
}
```

## When to Use ✅

- Manage UI state transitions
- Prevent invalid state combinations
- Single source of truth for screen state
- Consistent loading/error handling

## When NOT to Use ❌

- Very simple screens
- Multiple independent states needed
- Complex state machines
