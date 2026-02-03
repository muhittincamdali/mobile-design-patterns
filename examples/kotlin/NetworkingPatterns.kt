// NetworkingPatterns.kt
// Comprehensive networking implementations using design patterns

package com.example.patterns.networking

import kotlinx.coroutines.*
import kotlinx.coroutines.flow.*
import okhttp3.*
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.RequestBody.Companion.toRequestBody
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.*
import java.io.IOException
import java.util.concurrent.TimeUnit
import javax.inject.Inject
import javax.inject.Singleton

// MARK: - API Endpoint Definition

interface ApiEndpoint {
    val baseUrl: String
    val path: String
    val method: HttpMethod
    val headers: Map<String, String>
    val queryParams: Map<String, String>
    val body: Any?
    val timeout: Long
}

enum class HttpMethod {
    GET, POST, PUT, PATCH, DELETE
}

// MARK: - Concrete Endpoints

sealed class UserEndpoint : ApiEndpoint {
    override val baseUrl: String = "https://api.example.com/v1/"
    override val headers: Map<String, String> = mapOf(
        "Content-Type" to "application/json",
        "Accept" to "application/json"
    )
    override val queryParams: Map<String, String> = emptyMap()
    override val body: Any? = null
    override val timeout: Long = 30_000

    data class GetUser(val id: String) : UserEndpoint() {
        override val path: String = "users/$id"
        override val method: HttpMethod = HttpMethod.GET
    }

    data class ListUsers(val page: Int, val limit: Int) : UserEndpoint() {
        override val path: String = "users"
        override val method: HttpMethod = HttpMethod.GET
        override val queryParams: Map<String, String> = mapOf(
            "page" to page.toString(),
            "limit" to limit.toString()
        )
    }

    data class CreateUser(val request: CreateUserRequest) : UserEndpoint() {
        override val path: String = "users"
        override val method: HttpMethod = HttpMethod.POST
        override val body: Any = request
    }

    data class UpdateUser(val id: String, val request: UpdateUserRequest) : UserEndpoint() {
        override val path: String = "users/$id"
        override val method: HttpMethod = HttpMethod.PUT
        override val body: Any = request
    }

    data class DeleteUser(val id: String) : UserEndpoint() {
        override val path: String = "users/$id"
        override val method: HttpMethod = HttpMethod.DELETE
    }

    data class SearchUsers(val query: String) : UserEndpoint() {
        override val path: String = "users/search"
        override val method: HttpMethod = HttpMethod.GET
        override val queryParams: Map<String, String> = mapOf("q" to query)
    }
}

data class CreateUserRequest(
    val name: String,
    val email: String,
    val password: String
)

data class UpdateUserRequest(
    val name: String? = null,
    val email: String? = null,
    val avatarUrl: String? = null
)

// MARK: - Network Error

sealed class NetworkError : Exception() {
    object NoConnection : NetworkError()
    object Timeout : NetworkError()
    data class HttpError(val code: Int, val message: String) : NetworkError()
    data class ParseError(val cause: Throwable) : NetworkError()
    data class Unknown(override val cause: Throwable) : NetworkError()
}

// MARK: - Result Wrapper

sealed class NetworkResult<out T> {
    data class Success<T>(val data: T) : NetworkResult<T>()
    data class Error(val error: NetworkError) : NetworkResult<Nothing>()
    object Loading : NetworkResult<Nothing>()

    fun <R> map(transform: (T) -> R): NetworkResult<R> = when (this) {
        is Success -> Success(transform(data))
        is Error -> this
        is Loading -> Loading
    }

    fun onSuccess(action: (T) -> Unit): NetworkResult<T> {
        if (this is Success) action(data)
        return this
    }

    fun onError(action: (NetworkError) -> Unit): NetworkResult<T> {
        if (this is Error) action(error)
        return this
    }
}

// MARK: - Retrofit Service Interface

interface UserApiService {
    @GET("users/{id}")
    suspend fun getUser(@Path("id") id: String): UserResponse

    @GET("users")
    suspend fun listUsers(
        @Query("page") page: Int,
        @Query("limit") limit: Int
    ): PaginatedResponse<UserResponse>

    @POST("users")
    suspend fun createUser(@Body request: CreateUserRequest): UserResponse

    @PUT("users/{id}")
    suspend fun updateUser(
        @Path("id") id: String,
        @Body request: UpdateUserRequest
    ): UserResponse

    @DELETE("users/{id}")
    suspend fun deleteUser(@Path("id") id: String)

    @GET("users/search")
    suspend fun searchUsers(@Query("q") query: String): List<UserResponse>
}

data class UserResponse(
    val id: String,
    val name: String,
    val email: String,
    val avatarUrl: String?,
    val isActive: Boolean,
    val createdAt: Long
)

data class PaginatedResponse<T>(
    val items: List<T>,
    val page: Int,
    val totalPages: Int,
    val totalItems: Int
)

// MARK: - Interceptors (Chain of Responsibility Pattern)

class AuthInterceptor(
    private val tokenProvider: () -> String?
) : Interceptor {
    override fun intercept(chain: Interceptor.Chain): Response {
        val original = chain.request()
        val token = tokenProvider()

        val request = if (token != null) {
            original.newBuilder()
                .header("Authorization", "Bearer $token")
                .build()
        } else {
            original
        }

        return chain.proceed(request)
    }
}

class LoggingInterceptor : Interceptor {
    override fun intercept(chain: Interceptor.Chain): Response {
        val request = chain.request()
        val startTime = System.currentTimeMillis()

        println("➡️ ${request.method} ${request.url}")
        request.body?.let {
            println("   Body: ${it.contentType()}")
        }

        val response = chain.proceed(request)
        val duration = System.currentTimeMillis() - startTime

        println("⬅️ ${response.code} ${request.url} (${duration}ms)")

        return response
    }
}

class RetryInterceptor(
    private val maxRetries: Int = 3,
    private val initialDelay: Long = 1000
) : Interceptor {
    override fun intercept(chain: Interceptor.Chain): Response {
        var request = chain.request()
        var response: Response? = null
        var exception: IOException? = null

        repeat(maxRetries) { attempt ->
            try {
                response?.close()
                response = chain.proceed(request)

                if (response!!.isSuccessful) {
                    return response!!
                }

                // Retry on 5xx errors
                if (response!!.code in 500..599) {
                    val delay = initialDelay * (attempt + 1)
                    Thread.sleep(delay)
                } else {
                    return response!!
                }
            } catch (e: IOException) {
                exception = e
                if (attempt < maxRetries - 1) {
                    val delay = initialDelay * (attempt + 1)
                    Thread.sleep(delay)
                }
            }
        }

        throw exception ?: IOException("Max retries reached")
    }
}

class CacheInterceptor(
    private val cacheDurationSeconds: Int = 60
) : Interceptor {
    override fun intercept(chain: Interceptor.Chain): Response {
        var request = chain.request()

        // Add cache headers for GET requests
        if (request.method == "GET") {
            request = request.newBuilder()
                .header("Cache-Control", "public, max-age=$cacheDurationSeconds")
                .build()
        }

        return chain.proceed(request)
    }
}

// MARK: - Network Client Factory

@Singleton
class NetworkClientFactory @Inject constructor(
    private val tokenProvider: TokenProvider
) {
    fun createOkHttpClient(): OkHttpClient {
        return OkHttpClient.Builder()
            .addInterceptor(AuthInterceptor { tokenProvider.getToken() })
            .addInterceptor(LoggingInterceptor())
            .addInterceptor(RetryInterceptor())
            .addInterceptor(CacheInterceptor())
            .connectTimeout(30, TimeUnit.SECONDS)
            .readTimeout(30, TimeUnit.SECONDS)
            .writeTimeout(30, TimeUnit.SECONDS)
            .build()
    }

    fun createRetrofit(okHttpClient: OkHttpClient): Retrofit {
        return Retrofit.Builder()
            .baseUrl("https://api.example.com/v1/")
            .client(okHttpClient)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
    }
}

interface TokenProvider {
    fun getToken(): String?
    fun refreshToken(): String?
}

// MARK: - Repository Pattern

interface UserRepository {
    suspend fun getUser(id: String): NetworkResult<User>
    suspend fun listUsers(page: Int, limit: Int): NetworkResult<PaginatedData<User>>
    suspend fun createUser(request: CreateUserRequest): NetworkResult<User>
    suspend fun updateUser(id: String, request: UpdateUserRequest): NetworkResult<User>
    suspend fun deleteUser(id: String): NetworkResult<Unit>
    suspend fun searchUsers(query: String): NetworkResult<List<User>>
    fun observeUser(id: String): Flow<User?>
}

data class User(
    val id: String,
    val name: String,
    val email: String,
    val avatarUrl: String?,
    val isActive: Boolean,
    val createdAt: Long
)

data class PaginatedData<T>(
    val items: List<T>,
    val page: Int,
    val totalPages: Int,
    val totalItems: Int
)

@Singleton
class UserRepositoryImpl @Inject constructor(
    private val apiService: UserApiService,
    private val userDao: UserDao,
    private val dispatcher: CoroutineDispatcher = Dispatchers.IO
) : UserRepository {

    override suspend fun getUser(id: String): NetworkResult<User> = withContext(dispatcher) {
        try {
            val response = apiService.getUser(id)
            val user = response.toUser()
            userDao.insert(user.toEntity())
            NetworkResult.Success(user)
        } catch (e: Exception) {
            handleException(e)
        }
    }

    override suspend fun listUsers(page: Int, limit: Int): NetworkResult<PaginatedData<User>> =
        withContext(dispatcher) {
            try {
                val response = apiService.listUsers(page, limit)
                val users = response.items.map { it.toUser() }
                userDao.insertAll(users.map { it.toEntity() })
                NetworkResult.Success(
                    PaginatedData(
                        items = users,
                        page = response.page,
                        totalPages = response.totalPages,
                        totalItems = response.totalItems
                    )
                )
            } catch (e: Exception) {
                handleException(e)
            }
        }

    override suspend fun createUser(request: CreateUserRequest): NetworkResult<User> =
        withContext(dispatcher) {
            try {
                val response = apiService.createUser(request)
                val user = response.toUser()
                userDao.insert(user.toEntity())
                NetworkResult.Success(user)
            } catch (e: Exception) {
                handleException(e)
            }
        }

    override suspend fun updateUser(id: String, request: UpdateUserRequest): NetworkResult<User> =
        withContext(dispatcher) {
            try {
                val response = apiService.updateUser(id, request)
                val user = response.toUser()
                userDao.insert(user.toEntity())
                NetworkResult.Success(user)
            } catch (e: Exception) {
                handleException(e)
            }
        }

    override suspend fun deleteUser(id: String): NetworkResult<Unit> = withContext(dispatcher) {
        try {
            apiService.deleteUser(id)
            userDao.deleteById(id)
            NetworkResult.Success(Unit)
        } catch (e: Exception) {
            handleException(e)
        }
    }

    override suspend fun searchUsers(query: String): NetworkResult<List<User>> =
        withContext(dispatcher) {
            try {
                val response = apiService.searchUsers(query)
                NetworkResult.Success(response.map { it.toUser() })
            } catch (e: Exception) {
                handleException(e)
            }
        }

    override fun observeUser(id: String): Flow<User?> {
        return userDao.observeById(id).map { it?.toUser() }
    }

    private fun <T> handleException(e: Exception): NetworkResult<T> {
        return when (e) {
            is IOException -> NetworkResult.Error(NetworkError.NoConnection)
            is retrofit2.HttpException -> {
                NetworkResult.Error(
                    NetworkError.HttpError(e.code(), e.message())
                )
            }
            else -> NetworkResult.Error(NetworkError.Unknown(e))
        }
    }

    private fun UserResponse.toUser() = User(
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

    private fun UserEntity.toUser() = User(
        id = id,
        name = name,
        email = email,
        avatarUrl = avatarUrl,
        isActive = isActive,
        createdAt = createdAt
    )
}

// MARK: - Room Database Entities

data class UserEntity(
    val id: String,
    val name: String,
    val email: String,
    val avatarUrl: String?,
    val isActive: Boolean,
    val createdAt: Long
)

interface UserDao {
    fun observeById(id: String): Flow<UserEntity?>
    suspend fun insert(user: UserEntity)
    suspend fun insertAll(users: List<UserEntity>)
    suspend fun deleteById(id: String)
    suspend fun getById(id: String): UserEntity?
}

// MARK: - Caching Decorator

class CachingUserRepository(
    private val wrapped: UserRepository,
    private val cache: UserCache
) : UserRepository by wrapped {

    override suspend fun getUser(id: String): NetworkResult<User> {
        // Check cache first
        cache.get(id)?.let { cachedUser ->
            if (!cache.isExpired(id)) {
                return NetworkResult.Success(cachedUser)
            }
        }

        // Fetch from network
        val result = wrapped.getUser(id)

        // Cache successful result
        if (result is NetworkResult.Success) {
            cache.put(id, result.data)
        }

        return result
    }

    override suspend fun listUsers(page: Int, limit: Int): NetworkResult<PaginatedData<User>> {
        val cacheKey = "list_${page}_$limit"

        cache.getList(cacheKey)?.let { cachedList ->
            if (!cache.isListExpired(cacheKey)) {
                return NetworkResult.Success(cachedList)
            }
        }

        val result = wrapped.listUsers(page, limit)

        if (result is NetworkResult.Success) {
            cache.putList(cacheKey, result.data)
            result.data.items.forEach { user ->
                cache.put(user.id, user)
            }
        }

        return result
    }
}

class UserCache(
    private val maxAge: Long = 5 * 60 * 1000 // 5 minutes
) {
    private val userCache = mutableMapOf<String, CacheEntry<User>>()
    private val listCache = mutableMapOf<String, CacheEntry<PaginatedData<User>>>()

    fun get(id: String): User? = userCache[id]?.value
    fun put(id: String, user: User) {
        userCache[id] = CacheEntry(user, System.currentTimeMillis())
    }

    fun isExpired(id: String): Boolean {
        val entry = userCache[id] ?: return true
        return System.currentTimeMillis() - entry.timestamp > maxAge
    }

    fun getList(key: String): PaginatedData<User>? = listCache[key]?.value
    fun putList(key: String, data: PaginatedData<User>) {
        listCache[key] = CacheEntry(data, System.currentTimeMillis())
    }

    fun isListExpired(key: String): Boolean {
        val entry = listCache[key] ?: return true
        return System.currentTimeMillis() - entry.timestamp > maxAge
    }

    fun clear() {
        userCache.clear()
        listCache.clear()
    }

    private data class CacheEntry<T>(val value: T, val timestamp: Long)
}

// MARK: - Offline Support

class OfflineFirstUserRepository(
    private val remote: UserRepository,
    private val local: UserDao,
    private val connectivityChecker: ConnectivityChecker
) : UserRepository by remote {

    override suspend fun getUser(id: String): NetworkResult<User> {
        return if (connectivityChecker.isConnected()) {
            remote.getUser(id)
        } else {
            local.getById(id)?.let { entity ->
                NetworkResult.Success(entity.toUser())
            } ?: NetworkResult.Error(NetworkError.NoConnection)
        }
    }

    private fun UserEntity.toUser() = User(
        id = id,
        name = name,
        email = email,
        avatarUrl = avatarUrl,
        isActive = isActive,
        createdAt = createdAt
    )
}

interface ConnectivityChecker {
    fun isConnected(): Boolean
    fun observeConnectivity(): Flow<Boolean>
}

// MARK: - Request Queue (Command Pattern)

interface NetworkCommand {
    val id: String
    val priority: Int
    suspend fun execute(): NetworkResult<Any>
    fun cancel()
}

class RequestQueue(
    private val maxConcurrent: Int = 4,
    private val scope: CoroutineScope = CoroutineScope(Dispatchers.IO + SupervisorJob())
) {
    private val queue = java.util.PriorityQueue<NetworkCommand>(
        compareByDescending { it.priority }
    )
    private val running = mutableSetOf<String>()
    private val mutex = kotlinx.coroutines.sync.Mutex()

    suspend fun enqueue(command: NetworkCommand) {
        mutex.withLock {
            queue.add(command)
        }
        processQueue()
    }

    suspend fun cancel(id: String) {
        mutex.withLock {
            queue.removeAll { it.id == id }
        }
    }

    private suspend fun processQueue() {
        mutex.withLock {
            while (running.size < maxConcurrent && queue.isNotEmpty()) {
                val command = queue.poll() ?: break
                running.add(command.id)

                scope.launch {
                    try {
                        command.execute()
                    } finally {
                        mutex.withLock {
                            running.remove(command.id)
                        }
                        processQueue()
                    }
                }
            }
        }
    }
}

// MARK: - WebSocket Manager (Observer Pattern)

interface WebSocketListener {
    fun onMessage(message: WebSocketMessage)
    fun onStateChanged(state: WebSocketState)
    fun onError(error: Throwable)
}

enum class WebSocketState {
    DISCONNECTED, CONNECTING, CONNECTED, DISCONNECTING
}

data class WebSocketMessage(
    val type: String,
    val payload: Map<String, Any>,
    val timestamp: Long = System.currentTimeMillis()
)

class WebSocketManager(
    private val url: String,
    private val client: OkHttpClient = OkHttpClient()
) {
    private var webSocket: WebSocket? = null
    private val listeners = mutableSetOf<WebSocketListener>()
    private var state: WebSocketState = WebSocketState.DISCONNECTED
        set(value) {
            field = value
            listeners.forEach { it.onStateChanged(value) }
        }

    fun addListener(listener: WebSocketListener) {
        listeners.add(listener)
    }

    fun removeListener(listener: WebSocketListener) {
        listeners.remove(listener)
    }

    fun connect() {
        if (state != WebSocketState.DISCONNECTED) return

        state = WebSocketState.CONNECTING
        val request = Request.Builder().url(url).build()

        webSocket = client.newWebSocket(request, object : okhttp3.WebSocketListener() {
            override fun onOpen(webSocket: WebSocket, response: Response) {
                state = WebSocketState.CONNECTED
            }

            override fun onMessage(webSocket: WebSocket, text: String) {
                // Parse and notify listeners
                val message = WebSocketMessage(
                    type = "text",
                    payload = mapOf("content" to text)
                )
                listeners.forEach { it.onMessage(message) }
            }

            override fun onFailure(webSocket: WebSocket, t: Throwable, response: Response?) {
                state = WebSocketState.DISCONNECTED
                listeners.forEach { it.onError(t) }
            }

            override fun onClosed(webSocket: WebSocket, code: Int, reason: String) {
                state = WebSocketState.DISCONNECTED
            }
        })
    }

    fun disconnect() {
        state = WebSocketState.DISCONNECTING
        webSocket?.close(1000, "Client disconnect")
        webSocket = null
    }

    fun send(message: String) {
        webSocket?.send(message)
    }
}
