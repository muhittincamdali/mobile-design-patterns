// ArchitecturalPatterns.swift
// MVVM, Clean Architecture, and Coordinator implementations

import Foundation
import Combine
import UIKit

// MARK: - MVVM Base Components

protocol ViewModel: ObservableObject {
    associatedtype State
    associatedtype Action
    
    var state: State { get }
    func handle(_ action: Action)
}

protocol ViewModelBindable: AnyObject {
    associatedtype ViewModelType: ViewModel
    var viewModel: ViewModelType! { get set }
    func bind()
}

// MARK: - User List Feature (MVVM + Clean Architecture)

// Entity
struct UserEntity: Identifiable, Equatable {
    let id: String
    let name: String
    let email: String
    let avatarURL: URL?
    let isActive: Bool
    let createdAt: Date
}

// DTO
struct UserDTO: Codable {
    let id: String
    let name: String
    let email: String
    let avatarURL: String?
    let isActive: Bool
    let createdAt: Date
}

// Repository Protocol
protocol UserRepositoryProtocol {
    func fetchUsers(page: Int, pageSize: Int) async throws -> [UserDTO]
    func searchUsers(query: String) async throws -> [UserDTO]
    func deleteUser(id: String) async throws
    func getUser(id: String) async throws -> UserDTO
}

// Use Case Protocol
protocol FetchUsersUseCase {
    func execute(page: Int, pageSize: Int) async throws -> [UserEntity]
}

protocol SearchUsersUseCase {
    func execute(query: String) async throws -> [UserEntity]
}

protocol DeleteUserUseCase {
    func execute(userId: String) async throws
}

// Use Case Implementations
final class FetchUsersUseCaseImpl: FetchUsersUseCase {
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(page: Int, pageSize: Int) async throws -> [UserEntity] {
        let users = try await repository.fetchUsers(page: page, pageSize: pageSize)
        return users.map { mapToEntity($0) }
    }
    
    private func mapToEntity(_ dto: UserDTO) -> UserEntity {
        UserEntity(
            id: dto.id,
            name: dto.name,
            email: dto.email,
            avatarURL: dto.avatarURL.flatMap(URL.init),
            isActive: dto.isActive,
            createdAt: dto.createdAt
        )
    }
}

final class SearchUsersUseCaseImpl: SearchUsersUseCase {
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(query: String) async throws -> [UserEntity] {
        guard query.count >= 2 else { return [] }
        
        let users = try await repository.searchUsers(query: query)
        return users.map { mapToEntity($0) }
    }
    
    private func mapToEntity(_ dto: UserDTO) -> UserEntity {
        UserEntity(
            id: dto.id,
            name: dto.name,
            email: dto.email,
            avatarURL: dto.avatarURL.flatMap(URL.init),
            isActive: dto.isActive,
            createdAt: dto.createdAt
        )
    }
}

final class DeleteUserUseCaseImpl: DeleteUserUseCase {
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(userId: String) async throws {
        try await repository.deleteUser(id: userId)
    }
}

// MARK: - User List ViewModel

final class UserListViewModel: ObservableObject {
    
    // State
    struct State: Equatable {
        var users: [UserEntity] = []
        var isLoading: Bool = false
        var error: String? = nil
        var searchQuery: String = ""
        var currentPage: Int = 1
        var hasMorePages: Bool = true
        var selectedUserId: String? = nil
    }
    
    // Actions
    enum Action {
        case loadInitial
        case loadMore
        case search(query: String)
        case selectUser(id: String)
        case deleteUser(id: String)
        case retry
        case clearError
    }
    
    @Published private(set) var state = State()
    
    private let fetchUsersUseCase: FetchUsersUseCase
    private let searchUsersUseCase: SearchUsersUseCase
    private let deleteUserUseCase: DeleteUserUseCase
    
    private let pageSize = 20
    private var searchDebounceTask: Task<Void, Never>?
    
    var onUserSelected: ((String) -> Void)?
    
    init(
        fetchUsersUseCase: FetchUsersUseCase,
        searchUsersUseCase: SearchUsersUseCase,
        deleteUserUseCase: DeleteUserUseCase
    ) {
        self.fetchUsersUseCase = fetchUsersUseCase
        self.searchUsersUseCase = searchUsersUseCase
        self.deleteUserUseCase = deleteUserUseCase
    }
    
    func handle(_ action: Action) {
        switch action {
        case .loadInitial:
            loadInitialUsers()
        case .loadMore:
            loadMoreUsers()
        case .search(let query):
            searchUsers(query: query)
        case .selectUser(let id):
            selectUser(id: id)
        case .deleteUser(let id):
            deleteUser(id: id)
        case .retry:
            if state.searchQuery.isEmpty {
                loadInitialUsers()
            } else {
                searchUsers(query: state.searchQuery)
            }
        case .clearError:
            state.error = nil
        }
    }
    
    private func loadInitialUsers() {
        guard !state.isLoading else { return }
        
        state.isLoading = true
        state.error = nil
        state.currentPage = 1
        
        Task { @MainActor in
            do {
                let users = try await fetchUsersUseCase.execute(page: 1, pageSize: pageSize)
                state.users = users
                state.hasMorePages = users.count == pageSize
                state.isLoading = false
            } catch {
                state.error = error.localizedDescription
                state.isLoading = false
            }
        }
    }
    
    private func loadMoreUsers() {
        guard !state.isLoading && state.hasMorePages && state.searchQuery.isEmpty else { return }
        
        state.isLoading = true
        let nextPage = state.currentPage + 1
        
        Task { @MainActor in
            do {
                let users = try await fetchUsersUseCase.execute(page: nextPage, pageSize: pageSize)
                state.users.append(contentsOf: users)
                state.currentPage = nextPage
                state.hasMorePages = users.count == pageSize
                state.isLoading = false
            } catch {
                state.error = error.localizedDescription
                state.isLoading = false
            }
        }
    }
    
    private func searchUsers(query: String) {
        state.searchQuery = query
        
        searchDebounceTask?.cancel()
        
        if query.isEmpty {
            loadInitialUsers()
            return
        }
        
        searchDebounceTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 300_000_000) // 300ms debounce
            
            guard !Task.isCancelled else { return }
            
            state.isLoading = true
            state.error = nil
            
            do {
                let users = try await searchUsersUseCase.execute(query: query)
                state.users = users
                state.hasMorePages = false
                state.isLoading = false
            } catch {
                state.error = error.localizedDescription
                state.isLoading = false
            }
        }
    }
    
    private func selectUser(id: String) {
        state.selectedUserId = id
        onUserSelected?(id)
    }
    
    private func deleteUser(id: String) {
        Task { @MainActor in
            do {
                try await deleteUserUseCase.execute(userId: id)
                state.users.removeAll { $0.id == id }
            } catch {
                state.error = error.localizedDescription
            }
        }
    }
}

// MARK: - User Detail ViewModel

final class UserDetailViewModel: ObservableObject {
    
    struct State: Equatable {
        var user: UserEntity?
        var isLoading: Bool = false
        var error: String? = nil
        var isEditing: Bool = false
    }
    
    enum Action {
        case load
        case startEditing
        case cancelEditing
        case save(name: String, email: String)
        case delete
    }
    
    @Published private(set) var state = State()
    
    private let userId: String
    private let repository: UserRepositoryProtocol
    
    var onUserDeleted: (() -> Void)?
    var onDismiss: (() -> Void)?
    
    init(userId: String, repository: UserRepositoryProtocol) {
        self.userId = userId
        self.repository = repository
    }
    
    func handle(_ action: Action) {
        switch action {
        case .load:
            loadUser()
        case .startEditing:
            state.isEditing = true
        case .cancelEditing:
            state.isEditing = false
        case .save(let name, let email):
            saveUser(name: name, email: email)
        case .delete:
            deleteUser()
        }
    }
    
    private func loadUser() {
        state.isLoading = true
        state.error = nil
        
        Task { @MainActor in
            do {
                let dto = try await repository.getUser(id: userId)
                state.user = UserEntity(
                    id: dto.id,
                    name: dto.name,
                    email: dto.email,
                    avatarURL: dto.avatarURL.flatMap(URL.init),
                    isActive: dto.isActive,
                    createdAt: dto.createdAt
                )
                state.isLoading = false
            } catch {
                state.error = error.localizedDescription
                state.isLoading = false
            }
        }
    }
    
    private func saveUser(name: String, email: String) {
        guard let current = state.user else { return }
        
        state.isLoading = true
        
        Task { @MainActor in
            do {
                // Simulate API call
                try await Task.sleep(nanoseconds: 500_000_000)
                
                state.user = UserEntity(
                    id: current.id,
                    name: name,
                    email: email,
                    avatarURL: current.avatarURL,
                    isActive: current.isActive,
                    createdAt: current.createdAt
                )
                state.isEditing = false
                state.isLoading = false
            } catch {
                state.error = error.localizedDescription
                state.isLoading = false
            }
        }
    }
    
    private func deleteUser() {
        state.isLoading = true
        
        Task { @MainActor in
            do {
                try await repository.deleteUser(id: userId)
                onUserDeleted?()
            } catch {
                state.error = error.localizedDescription
                state.isLoading = false
            }
        }
    }
}

// MARK: - Coordinator Protocol

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get }
    func start()
}

extension Coordinator {
    func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}

// MARK: - App Coordinator

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    private let window: UIWindow
    private let dependencyContainer: DependencyContainerProtocol
    
    init(window: UIWindow, dependencyContainer: DependencyContainerProtocol) {
        self.window = window
        self.dependencyContainer = dependencyContainer
        self.navigationController = UINavigationController()
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        showUserList()
    }
    
    private func showUserList() {
        let coordinator = UserListCoordinator(
            navigationController: navigationController,
            dependencyContainer: dependencyContainer
        )
        addChild(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
}

// MARK: - User List Coordinator

final class UserListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    weak var parentCoordinator: Coordinator?
    
    private let dependencyContainer: DependencyContainerProtocol
    
    init(
        navigationController: UINavigationController,
        dependencyContainer: DependencyContainerProtocol
    ) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
    }
    
    func start() {
        let viewModel = dependencyContainer.makeUserListViewModel()
        viewModel.onUserSelected = { [weak self] userId in
            self?.showUserDetail(userId: userId)
        }
        
        let viewController = UserListViewController(viewModel: viewModel)
        viewController.title = "Users"
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showUserDetail(userId: String) {
        let coordinator = UserDetailCoordinator(
            userId: userId,
            navigationController: navigationController,
            dependencyContainer: dependencyContainer
        )
        addChild(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
}

// MARK: - User Detail Coordinator

final class UserDetailCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    weak var parentCoordinator: Coordinator?
    
    private let userId: String
    private let dependencyContainer: DependencyContainerProtocol
    
    init(
        userId: String,
        navigationController: UINavigationController,
        dependencyContainer: DependencyContainerProtocol
    ) {
        self.userId = userId
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
    }
    
    func start() {
        let viewModel = dependencyContainer.makeUserDetailViewModel(userId: userId)
        viewModel.onUserDeleted = { [weak self] in
            self?.dismiss()
        }
        viewModel.onDismiss = { [weak self] in
            self?.dismiss()
        }
        
        let viewController = UserDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func dismiss() {
        navigationController.popViewController(animated: true)
        (parentCoordinator as? UserListCoordinator)?.removeChild(self)
    }
}

// MARK: - Dependency Container

protocol DependencyContainerProtocol {
    func makeUserListViewModel() -> UserListViewModel
    func makeUserDetailViewModel(userId: String) -> UserDetailViewModel
}

final class DependencyContainer: DependencyContainerProtocol {
    private lazy var userRepository: UserRepositoryProtocol = UserRepositoryImpl()
    
    func makeUserListViewModel() -> UserListViewModel {
        let fetchUseCase = FetchUsersUseCaseImpl(repository: userRepository)
        let searchUseCase = SearchUsersUseCaseImpl(repository: userRepository)
        let deleteUseCase = DeleteUserUseCaseImpl(repository: userRepository)
        
        return UserListViewModel(
            fetchUsersUseCase: fetchUseCase,
            searchUsersUseCase: searchUseCase,
            deleteUserUseCase: deleteUseCase
        )
    }
    
    func makeUserDetailViewModel(userId: String) -> UserDetailViewModel {
        return UserDetailViewModel(userId: userId, repository: userRepository)
    }
}

// MARK: - Mock Repository

final class UserRepositoryImpl: UserRepositoryProtocol {
    private var users: [UserDTO] = (1...100).map { i in
        UserDTO(
            id: "user_\(i)",
            name: "User \(i)",
            email: "user\(i)@example.com",
            avatarURL: "https://api.dicebear.com/7.x/avataaars/svg?seed=\(i)",
            isActive: i % 3 != 0,
            createdAt: Date().addingTimeInterval(-Double(i) * 86400)
        )
    }
    
    func fetchUsers(page: Int, pageSize: Int) async throws -> [UserDTO] {
        try await Task.sleep(nanoseconds: 500_000_000)
        
        let start = (page - 1) * pageSize
        let end = min(start + pageSize, users.count)
        
        guard start < users.count else { return [] }
        
        return Array(users[start..<end])
    }
    
    func searchUsers(query: String) async throws -> [UserDTO] {
        try await Task.sleep(nanoseconds: 300_000_000)
        
        return users.filter {
            $0.name.localizedCaseInsensitiveContains(query) ||
            $0.email.localizedCaseInsensitiveContains(query)
        }
    }
    
    func deleteUser(id: String) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
        users.removeAll { $0.id == id }
    }
    
    func getUser(id: String) async throws -> UserDTO {
        try await Task.sleep(nanoseconds: 300_000_000)
        
        guard let user = users.first(where: { $0.id == id }) else {
            throw NSError(domain: "UserNotFound", code: 404)
        }
        
        return user
    }
}

// MARK: - View Controllers

final class UserListViewController: UIViewController {
    private let viewModel: UserListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search users"
        return controller
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        viewModel.handle(.loadInitial)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
        tableView.tableFooterView = loadingIndicator
    }
    
    private func bind() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.updateUI(with: state)
            }
            .store(in: &cancellables)
    }
    
    private func updateUI(with state: UserListViewModel.State) {
        tableView.reloadData()
        
        if state.isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
        
        if let error = state.error {
            showError(error)
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.viewModel.handle(.clearError)
        })
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.viewModel.handle(.retry)
        })
        present(alert, animated: true)
    }
}

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.state.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let user = viewModel.state.users[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = user.name
        content.secondaryText = user.email
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = viewModel.state.users[indexPath.row]
        viewModel.handle(.selectUser(id: user.id))
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isNearEnd = indexPath.row >= viewModel.state.users.count - 5
        if isNearEnd {
            viewModel.handle(.loadMore)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            guard let self = self else {
                completion(false)
                return
            }
            let user = self.viewModel.state.users[indexPath.row]
            self.viewModel.handle(.deleteUser(id: user.id))
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension UserListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.handle(.search(query: searchText))
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.handle(.search(query: ""))
    }
}

final class UserDetailViewController: UIViewController {
    private let viewModel: UserDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let statusLabel = UILabel()
    private let dateLabel = UILabel()
    
    init(viewModel: UserDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        viewModel.handle(.load)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "User Details"
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        [nameLabel, emailLabel, statusLabel, dateLabel].forEach {
            $0.font = .systemFont(ofSize: 16)
            stackView.addArrangedSubview($0)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(editTapped)
        )
    }
    
    private func bind() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.updateUI(with: state)
            }
            .store(in: &cancellables)
    }
    
    private func updateUI(with state: UserDetailViewModel.State) {
        guard let user = state.user else { return }
        
        nameLabel.text = "Name: \(user.name)"
        emailLabel.text = "Email: \(user.email)"
        statusLabel.text = "Status: \(user.isActive ? "Active" : "Inactive")"
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateLabel.text = "Created: \(formatter.string(from: user.createdAt))"
    }
    
    @objc private func editTapped() {
        viewModel.handle(.startEditing)
    }
}

// MARK: - Router Pattern Alternative

protocol Router {
    func route(to destination: any Routable)
    func dismiss()
}

protocol Routable {
    var identifier: String { get }
}

enum AppDestination: Routable {
    case userList
    case userDetail(userId: String)
    case settings
    case profile
    
    var identifier: String {
        switch self {
        case .userList: return "userList"
        case .userDetail(let id): return "userDetail_\(id)"
        case .settings: return "settings"
        case .profile: return "profile"
        }
    }
}

final class NavigationRouter: Router {
    private let navigationController: UINavigationController
    private let factory: ViewControllerFactory
    
    init(navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func route(to destination: any Routable) {
        guard let appDestination = destination as? AppDestination else { return }
        
        let viewController = factory.makeViewController(for: appDestination)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func dismiss() {
        navigationController.popViewController(animated: true)
    }
}

protocol ViewControllerFactory {
    func makeViewController(for destination: AppDestination) -> UIViewController
}

final class DefaultViewControllerFactory: ViewControllerFactory {
    private let container: DependencyContainerProtocol
    
    init(container: DependencyContainerProtocol) {
        self.container = container
    }
    
    func makeViewController(for destination: AppDestination) -> UIViewController {
        switch destination {
        case .userList:
            return UserListViewController(viewModel: container.makeUserListViewModel())
        case .userDetail(let userId):
            return UserDetailViewController(viewModel: container.makeUserDetailViewModel(userId: userId))
        case .settings:
            return UIViewController() // Placeholder
        case .profile:
            return UIViewController() // Placeholder
        }
    }
}
