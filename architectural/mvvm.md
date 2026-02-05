# MVVM Pattern

> Model-View-ViewModel for declarative UI frameworks

## Problem

- Need testable presentation logic
- UI framework (SwiftUI) is declarative
- Want separation between UI and business logic

## Solution

```swift
// MARK: - Model
struct User: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
    let avatarURL: URL?
    let createdAt: Date
}

struct UserProfile {
    let user: User
    let postsCount: Int
    let followersCount: Int
    let followingCount: Int
}

// MARK: - Service Layer
protocol UserServiceProtocol {
    func fetchUser(id: String) async throws -> User
    func fetchProfile(id: String) async throws -> UserProfile
    func updateUser(_ user: User) async throws -> User
}

class UserService: UserServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchUser(id: String) async throws -> User {
        try await networkClient.fetch(endpoint: .user(id: id))
    }
    
    func fetchProfile(id: String) async throws -> UserProfile {
        try await networkClient.fetch(endpoint: .userProfile(id: id))
    }
    
    func updateUser(_ user: User) async throws -> User {
        try await networkClient.post(endpoint: .updateUser, body: user)
    }
}

// MARK: - ViewModel
@MainActor
class UserProfileViewModel: ObservableObject {
    // Published State
    @Published private(set) var profile: UserProfile?
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    @Published var isEditing = false
    
    // Computed Properties
    var displayName: String {
        profile?.user.name ?? "Unknown"
    }
    
    var statsText: String {
        guard let profile = profile else { return "" }
        return "\(profile.postsCount) posts • \(profile.followersCount) followers"
    }
    
    var avatarURL: URL? {
        profile?.user.avatarURL
    }
    
    var hasError: Bool {
        error != nil
    }
    
    // Dependencies
    private let userService: UserServiceProtocol
    private let userId: String
    
    init(userId: String, userService: UserServiceProtocol) {
        self.userId = userId
        self.userService = userService
    }
    
    // Actions
    func loadProfile() async {
        isLoading = true
        error = nil
        
        do {
            profile = try await userService.fetchProfile(id: userId)
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func refresh() async {
        await loadProfile()
    }
    
    func startEditing() {
        isEditing = true
    }
    
    func cancelEditing() {
        isEditing = false
    }
    
    func saveChanges(name: String, email: String) async {
        guard var user = profile?.user else { return }
        
        isLoading = true
        
        let updatedUser = User(
            id: user.id,
            name: name,
            email: email,
            avatarURL: user.avatarURL,
            createdAt: user.createdAt
        )
        
        do {
            let savedUser = try await userService.updateUser(updatedUser)
            if let currentProfile = profile {
                profile = UserProfile(
                    user: savedUser,
                    postsCount: currentProfile.postsCount,
                    followersCount: currentProfile.followersCount,
                    followingCount: currentProfile.followingCount
                )
            }
            isEditing = false
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
}

// MARK: - View
struct UserProfileView: View {
    @StateObject private var viewModel: UserProfileViewModel
    
    init(userId: String, userService: UserServiceProtocol = UserService(networkClient: .shared)) {
        _viewModel = StateObject(wrappedValue: UserProfileViewModel(
            userId: userId,
            userService: userService
        ))
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.profile == nil {
                ProgressView()
            } else if let error = viewModel.error {
                ErrorView(error: error) {
                    Task { await viewModel.loadProfile() }
                }
            } else {
                profileContent
            }
        }
        .navigationTitle("Profile")
        .task {
            await viewModel.loadProfile()
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
    
    private var profileContent: some View {
        ScrollView {
            VStack(spacing: 16) {
                AsyncImage(url: viewModel.avatarURL) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                
                Text(viewModel.displayName)
                    .font(.title)
                    .bold()
                
                Text(viewModel.statsText)
                    .foregroundColor(.secondary)
                
                Button("Edit Profile") {
                    viewModel.startEditing()
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .sheet(isPresented: $viewModel.isEditing) {
            EditProfileSheet(viewModel: viewModel)
        }
    }
}

// MARK: - Unit Tests
class UserProfileViewModelTests: XCTestCase {
    var sut: UserProfileViewModel!
    var mockService: MockUserService!
    
    @MainActor
    override func setUp() {
        mockService = MockUserService()
        sut = UserProfileViewModel(userId: "123", userService: mockService)
    }
    
    @MainActor
    func testLoadProfile_Success() async {
        let expectedProfile = UserProfile(
            user: User(id: "123", name: "John", email: "john@test.com", avatarURL: nil, createdAt: Date()),
            postsCount: 10,
            followersCount: 100,
            followingCount: 50
        )
        mockService.profileResult = .success(expectedProfile)
        
        await sut.loadProfile()
        
        XCTAssertEqual(sut.displayName, "John")
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
    }
    
    @MainActor
    func testLoadProfile_Failure() async {
        mockService.profileResult = .failure(NSError(domain: "test", code: 0))
        
        await sut.loadProfile()
        
        XCTAssertTrue(sut.hasError)
        XCTAssertNil(sut.profile)
    }
}
```

## When to Use ✅

- SwiftUI apps
- Need testable presentation logic
- Two-way data binding
- Reactive frameworks (Combine)

## When NOT to Use ❌

- Very simple screens
- No testability requirements
- UIKit without reactive binding

## Related Patterns

- **MVP**: Similar but with Presenter
- **MVC**: Simpler, less testable
- **VIPER**: More complex, more modular
