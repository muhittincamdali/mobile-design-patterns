// ArchitecturalPatterns.kt
// MVVM, Clean Architecture, and Navigation implementations

package com.example.patterns.architecture

import androidx.lifecycle.*
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.*
import javax.inject.Inject

// MARK: - Domain Layer (Entities & Use Cases)

// Entity
data class User(
    val id: String,
    val name: String,
    val email: String,
    val avatarUrl: String?,
    val isActive: Boolean,
    val createdAt: Long
)

// Use Case Protocol
interface UseCase<in P, out R> {
    suspend operator fun invoke(params: P): R
}

interface FlowUseCase<in P, out R> {
    operator fun invoke(params: P): Flow<R>
}

// Concrete Use Cases
class GetUserUseCase @Inject constructor(
    private val repository: UserRepository
) : UseCase<String, Result<User>> {
    override suspend fun invoke(params: String): Result<User> {
        return repository.getUser(params)
    }
}

class GetUsersUseCase @Inject constructor(
    private val repository: UserRepository
) : UseCase<GetUsersUseCase.Params, Result<List<User>>> {

    data class Params(val page: Int, val pageSize: Int)

    override suspend fun invoke(params: Params): Result<List<User>> {
        return repository.getUsers(params.page, params.pageSize)
    }
}

class SearchUsersUseCase @Inject constructor(
    private val repository: UserRepository
) : UseCase<String, Result<List<User>>> {
    override suspend fun invoke(params: String): Result<List<User>> {
        if (params.length < 2) return Result.success(emptyList())
        return repository.searchUsers(params)
    }
}

class DeleteUserUseCase @Inject constructor(
    private val repository: UserRepository
) : UseCase<String, Result<Unit>> {
    override suspend fun invoke(params: String): Result<Unit> {
        return repository.deleteUser(params)
    }
}

class ObserveUserUseCase @Inject constructor(
    private val repository: UserRepository
) : FlowUseCase<String, User?> {
    override fun invoke(params: String): Flow<User?> {
        return repository.observeUser(params)
    }
}

// Repository Interface (Domain Layer)
interface UserRepository {
    suspend fun getUser(id: String): Result<User>
    suspend fun getUsers(page: Int, pageSize: Int): Result<List<User>>
    suspend fun searchUsers(query: String): Result<List<User>>
    suspend fun deleteUser(id: String): Result<Unit>
    fun observeUser(id: String): Flow<User?>
}

// MARK: - Presentation Layer (ViewModels)

// Base ViewModel with common functionality
abstract class BaseViewModel : ViewModel() {
    protected val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading.asStateFlow()

    protected val _error = MutableSharedFlow<String>()
    val error: SharedFlow<String> = _error.asSharedFlow()

    protected fun launchWithLoading(block: suspend () -> Unit) {
        viewModelScope.launch {
            _isLoading.value = true
            try {
                block()
            } finally {
                _isLoading.value = false
            }
        }
    }

    protected suspend fun <T> Result<T>.handleError(): T? {
        return fold(
            onSuccess = { it },
            onFailure = {
                _error.emit(it.message ?: "Unknown error")
                null
            }
        )
    }
}

// User List ViewModel
class UserListViewModel @Inject constructor(
    private val getUsersUseCase: GetUsersUseCase,
    private val searchUsersUseCase: SearchUsersUseCase,
    private val deleteUserUseCase: DeleteUserUseCase
) : BaseViewModel() {

    // UI State
    data class UiState(
        val users: List<User> = emptyList(),
        val isLoading: Boolean = false,
        val error: String? = null,
        val searchQuery: String = "",
        val currentPage: Int = 1,
        val hasMorePages: Boolean = true,
        val isSearching: Boolean = false
    )

    // Events (one-time actions)
    sealed class Event {
        data class NavigateToDetail(val userId: String) : Event()
        data class ShowSnackbar(val message: String) : Event()
        object ScrollToTop : Event()
    }

    // Actions (user intents)
    sealed class Action {
        object LoadInitial : Action()
        object LoadMore : Action()
        data class Search(val query: String) : Action()
        data class SelectUser(val userId: String) : Action()
        data class DeleteUser(val userId: String) : Action()
        object Retry : Action()
        object ClearError : Action()
    }

    private val _uiState = MutableStateFlow(UiState())
    val uiState: StateFlow<UiState> = _uiState.asStateFlow()

    private val _events = MutableSharedFlow<Event>()
    val events: SharedFlow<Event> = _events.asSharedFlow()

    private var searchJob: Job? = null
    private val pageSize = 20

    fun handleAction(action: Action) {
        when (action) {
            is Action.LoadInitial -> loadInitialUsers()
            is Action.LoadMore -> loadMoreUsers()
            is Action.Search -> searchUsers(action.query)
            is Action.SelectUser -> selectUser(action.userId)
            is Action.DeleteUser -> deleteUser(action.userId)
            is Action.Retry -> retry()
            is Action.ClearError -> clearError()
        }
    }

    private fun loadInitialUsers() {
        if (_uiState.value.isLoading) return

        viewModelScope.launch {
            _uiState.update { it.copy(isLoading = true, error = null, currentPage = 1) }

            getUsersUseCase(GetUsersUseCase.Params(1, pageSize))
                .fold(
                    onSuccess = { users ->
                        _uiState.update {
                            it.copy(
                                users = users,
                                hasMorePages = users.size == pageSize,
                                isLoading = false
                            )
                        }
                    },
                    onFailure = { error ->
                        _uiState.update {
                            it.copy(error = error.message, isLoading = false)
                        }
                    }
                )
        }
    }

    private fun loadMoreUsers() {
        val currentState = _uiState.value
        if (currentState.isLoading || !currentState.hasMorePages || currentState.isSearching) return

        viewModelScope.launch {
            _uiState.update { it.copy(isLoading = true) }

            val nextPage = currentState.currentPage + 1
            getUsersUseCase(GetUsersUseCase.Params(nextPage, pageSize))
                .fold(
                    onSuccess = { users ->
                        _uiState.update {
                            it.copy(
                                users = it.users + users,
                                currentPage = nextPage,
                                hasMorePages = users.size == pageSize,
                                isLoading = false
                            )
                        }
                    },
                    onFailure = { error ->
                        _uiState.update {
                            it.copy(error = error.message, isLoading = false)
                        }
                    }
                )
        }
    }

    private fun searchUsers(query: String) {
        _uiState.update { it.copy(searchQuery = query) }

        searchJob?.cancel()

        if (query.isEmpty()) {
            _uiState.update { it.copy(isSearching = false) }
            loadInitialUsers()
            return
        }

        searchJob = viewModelScope.launch {
            delay(300) // Debounce

            _uiState.update { it.copy(isLoading = true, isSearching = true) }

            searchUsersUseCase(query)
                .fold(
                    onSuccess = { users ->
                        _uiState.update {
                            it.copy(
                                users = users,
                                hasMorePages = false,
                                isLoading = false
                            )
                        }
                    },
                    onFailure = { error ->
                        _uiState.update {
                            it.copy(error = error.message, isLoading = false)
                        }
                    }
                )
        }
    }

    private fun selectUser(userId: String) {
        viewModelScope.launch {
            _events.emit(Event.NavigateToDetail(userId))
        }
    }

    private fun deleteUser(userId: String) {
        viewModelScope.launch {
            deleteUserUseCase(userId)
                .fold(
                    onSuccess = {
                        _uiState.update {
                            it.copy(users = it.users.filter { user -> user.id != userId })
                        }
                        _events.emit(Event.ShowSnackbar("User deleted"))
                    },
                    onFailure = { error ->
                        _events.emit(Event.ShowSnackbar(error.message ?: "Delete failed"))
                    }
                )
        }
    }

    private fun retry() {
        if (_uiState.value.searchQuery.isEmpty()) {
            loadInitialUsers()
        } else {
            searchUsers(_uiState.value.searchQuery)
        }
    }

    private fun clearError() {
        _uiState.update { it.copy(error = null) }
    }
}

// User Detail ViewModel
class UserDetailViewModel @Inject constructor(
    private val getUserUseCase: GetUserUseCase,
    private val deleteUserUseCase: DeleteUserUseCase,
    private val observeUserUseCase: ObserveUserUseCase,
    private val savedStateHandle: SavedStateHandle
) : BaseViewModel() {

    data class UiState(
        val user: User? = null,
        val isLoading: Boolean = false,
        val error: String? = null,
        val isEditing: Boolean = false
    )

    sealed class Event {
        object NavigateBack : Event()
        data class ShowSnackbar(val message: String) : Event()
    }

    sealed class Action {
        object Load : Action()
        object StartEditing : Action()
        object CancelEditing : Action()
        data class Save(val name: String, val email: String) : Action()
        object Delete : Action()
    }

    private val userId: String = savedStateHandle.get<String>("userId")
        ?: throw IllegalArgumentException("userId is required")

    private val _uiState = MutableStateFlow(UiState())
    val uiState: StateFlow<UiState> = _uiState.asStateFlow()

    private val _events = MutableSharedFlow<Event>()
    val events: SharedFlow<Event> = _events.asSharedFlow()

    init {
        observeUser()
    }

    fun handleAction(action: Action) {
        when (action) {
            is Action.Load -> loadUser()
            is Action.StartEditing -> startEditing()
            is Action.CancelEditing -> cancelEditing()
            is Action.Save -> saveUser(action.name, action.email)
            is Action.Delete -> deleteUser()
        }
    }

    private fun observeUser() {
        viewModelScope.launch {
            observeUserUseCase(userId).collect { user ->
                _uiState.update { it.copy(user = user) }
            }
        }
    }

    private fun loadUser() {
        viewModelScope.launch {
            _uiState.update { it.copy(isLoading = true, error = null) }

            getUserUseCase(userId)
                .fold(
                    onSuccess = { user ->
                        _uiState.update { it.copy(user = user, isLoading = false) }
                    },
                    onFailure = { error ->
                        _uiState.update {
                            it.copy(error = error.message, isLoading = false)
                        }
                    }
                )
        }
    }

    private fun startEditing() {
        _uiState.update { it.copy(isEditing = true) }
    }

    private fun cancelEditing() {
        _uiState.update { it.copy(isEditing = false) }
    }

    private fun saveUser(name: String, email: String) {
        viewModelScope.launch {
            _uiState.update { it.copy(isLoading = true) }

            // Simulate save
            delay(500)

            _uiState.update { state ->
                state.copy(
                    user = state.user?.copy(name = name, email = email),
                    isEditing = false,
                    isLoading = false
                )
            }
            _events.emit(Event.ShowSnackbar("User updated"))
        }
    }

    private fun deleteUser() {
        viewModelScope.launch {
            _uiState.update { it.copy(isLoading = true) }

            deleteUserUseCase(userId)
                .fold(
                    onSuccess = {
                        _events.emit(Event.NavigateBack)
                    },
                    onFailure = { error ->
                        _uiState.update { it.copy(isLoading = false) }
                        _events.emit(Event.ShowSnackbar(error.message ?: "Delete failed"))
                    }
                )
        }
    }
}

// MARK: - Navigation (Coordinator Pattern)

interface Navigator {
    fun navigateTo(destination: Destination)
    fun navigateBack()
    fun navigateBackTo(destination: Destination)
}

sealed class Destination {
    object UserList : Destination()
    data class UserDetail(val userId: String) : Destination()
    object Settings : Destination()
    object Profile : Destination()
}

class AppNavigator @Inject constructor(
    // NavController would be injected here
) : Navigator {
    override fun navigateTo(destination: Destination) {
        when (destination) {
            is Destination.UserList -> {
                // navController.navigate("users")
            }
            is Destination.UserDetail -> {
                // navController.navigate("users/${destination.userId}")
            }
            is Destination.Settings -> {
                // navController.navigate("settings")
            }
            is Destination.Profile -> {
                // navController.navigate("profile")
            }
        }
    }

    override fun navigateBack() {
        // navController.popBackStack()
    }

    override fun navigateBackTo(destination: Destination) {
        // navController.popBackStack(destination.route, inclusive = false)
    }
}

// MARK: - State Management (MVI Pattern)

interface MviViewModel<S, E, A> {
    val state: StateFlow<S>
    val effects: SharedFlow<E>
    fun handleAction(action: A)
}

// Example MVI implementation
data class CounterState(
    val count: Int = 0,
    val isLoading: Boolean = false
)

sealed class CounterEffect {
    data class ShowToast(val message: String) : CounterEffect()
}

sealed class CounterAction {
    object Increment : CounterAction()
    object Decrement : CounterAction()
    object Reset : CounterAction()
    data class SetValue(val value: Int) : CounterAction()
}

class CounterViewModel : ViewModel(), MviViewModel<CounterState, CounterEffect, CounterAction> {

    private val _state = MutableStateFlow(CounterState())
    override val state: StateFlow<CounterState> = _state.asStateFlow()

    private val _effects = MutableSharedFlow<CounterEffect>()
    override val effects: SharedFlow<CounterEffect> = _effects.asSharedFlow()

    override fun handleAction(action: CounterAction) {
        when (action) {
            is CounterAction.Increment -> {
                _state.update { it.copy(count = it.count + 1) }
            }
            is CounterAction.Decrement -> {
                _state.update { it.copy(count = maxOf(0, it.count - 1)) }
            }
            is CounterAction.Reset -> {
                _state.update { it.copy(count = 0) }
                viewModelScope.launch {
                    _effects.emit(CounterEffect.ShowToast("Counter reset"))
                }
            }
            is CounterAction.SetValue -> {
                _state.update { it.copy(count = action.value) }
            }
        }
    }
}

// MARK: - Dependency Injection Setup (Hilt)

/*
@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Provides
    @Singleton
    fun provideUserRepository(
        api: UserApi,
        dao: UserDao
    ): UserRepository = UserRepositoryImpl(api, dao)

    @Provides
    @Singleton
    fun provideGetUserUseCase(
        repository: UserRepository
    ): GetUserUseCase = GetUserUseCase(repository)

    @Provides
    @Singleton
    fun provideGetUsersUseCase(
        repository: UserRepository
    ): GetUsersUseCase = GetUsersUseCase(repository)
}

@Module
@InstallIn(ViewModelComponent::class)
object ViewModelModule {

    @Provides
    fun provideUserListViewModel(
        getUsersUseCase: GetUsersUseCase,
        searchUsersUseCase: SearchUsersUseCase,
        deleteUserUseCase: DeleteUserUseCase
    ): UserListViewModel = UserListViewModel(
        getUsersUseCase,
        searchUsersUseCase,
        deleteUserUseCase
    )
}
*/

// MARK: - Repository Implementation

class UserRepositoryImpl @Inject constructor(
    private val api: UserApi,
    private val dao: UserDao,
    private val dispatcher: CoroutineDispatcher = Dispatchers.IO
) : UserRepository {

    override suspend fun getUser(id: String): Result<User> = withContext(dispatcher) {
        runCatching {
            val response = api.getUser(id)
            val user = response.toDomain()
            dao.insert(user.toEntity())
            user
        }
    }

    override suspend fun getUsers(page: Int, pageSize: Int): Result<List<User>> =
        withContext(dispatcher) {
            runCatching {
                val response = api.getUsers(page, pageSize)
                val users = response.map { it.toDomain() }
                dao.insertAll(users.map { it.toEntity() })
                users
            }
        }

    override suspend fun searchUsers(query: String): Result<List<User>> = withContext(dispatcher) {
        runCatching {
            val response = api.searchUsers(query)
            response.map { it.toDomain() }
        }
    }

    override suspend fun deleteUser(id: String): Result<Unit> = withContext(dispatcher) {
        runCatching {
            api.deleteUser(id)
            dao.deleteById(id)
        }
    }

    override fun observeUser(id: String): Flow<User?> {
        return dao.observeById(id).map { it?.toDomain() }
    }

    // Mappers
    private fun UserResponse.toDomain() = User(
        id = id,
        name = name,
        email = email,
        avatarUrl = avatarUrl,
        isActive = isActive,
        createdAt = createdAt
    )

    private fun User.toEntity() = UserEntity(
        id = id,
        name = name,
        email = email,
        avatarUrl = avatarUrl,
        isActive = isActive,
        createdAt = createdAt
    )

    private fun UserEntity.toDomain() = User(
        id = id,
        name = name,
        email = email,
        avatarUrl = avatarUrl,
        isActive = isActive,
        createdAt = createdAt
    )
}

// API Interface
interface UserApi {
    suspend fun getUser(id: String): UserResponse
    suspend fun getUsers(page: Int, pageSize: Int): List<UserResponse>
    suspend fun searchUsers(query: String): List<UserResponse>
    suspend fun deleteUser(id: String)
}

data class UserResponse(
    val id: String,
    val name: String,
    val email: String,
    val avatarUrl: String?,
    val isActive: Boolean,
    val createdAt: Long
)

// Room DAO
interface UserDao {
    fun observeById(id: String): Flow<UserEntity?>
    suspend fun insert(user: UserEntity)
    suspend fun insertAll(users: List<UserEntity>)
    suspend fun deleteById(id: String)
}

data class UserEntity(
    val id: String,
    val name: String,
    val email: String,
    val avatarUrl: String?,
    val isActive: Boolean,
    val createdAt: Long
)
