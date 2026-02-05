# Repository Pattern

> Abstract data sources and provide single source of truth

## Problem

- Multiple data sources (API, cache, database)
- Business logic shouldn't know about data source
- Need offline support
- Want consistent data access patterns

## Solution

```swift
// MARK: - Domain Model
struct Article: Identifiable, Equatable {
    let id: String
    let title: String
    let content: String
    let author: Author
    let publishedAt: Date
    let imageURL: URL?
}

// MARK: - Repository Protocol
protocol ArticleRepository {
    func getArticle(id: String) async throws -> Article
    func getArticles(page: Int, limit: Int) async throws -> [Article]
    func searchArticles(query: String) async throws -> [Article]
    func saveArticle(_ article: Article) async throws
    func deleteArticle(id: String) async throws
    func observeArticle(id: String) -> AsyncStream<Article>
}

// MARK: - Data Sources
protocol ArticleRemoteDataSource {
    func fetchArticle(id: String) async throws -> ArticleDTO
    func fetchArticles(page: Int, limit: Int) async throws -> [ArticleDTO]
    func searchArticles(query: String) async throws -> [ArticleDTO]
}

protocol ArticleLocalDataSource {
    func getArticle(id: String) async throws -> ArticleEntity?
    func getArticles() async throws -> [ArticleEntity]
    func saveArticle(_ entity: ArticleEntity) async throws
    func saveArticles(_ entities: [ArticleEntity]) async throws
    func deleteArticle(id: String) async throws
    func observeArticle(id: String) -> AsyncStream<ArticleEntity?>
}

// MARK: - DTO (Data Transfer Object)
struct ArticleDTO: Codable {
    let id: String
    let title: String
    let content: String
    let authorId: String
    let authorName: String
    let publishedAt: String
    let imageUrl: String?
    
    func toDomain() -> Article {
        Article(
            id: id,
            title: title,
            content: content,
            author: Author(id: authorId, name: authorName),
            publishedAt: ISO8601DateFormatter().date(from: publishedAt) ?? Date(),
            imageURL: imageUrl.flatMap { URL(string: $0) }
        )
    }
}

// MARK: - Entity (Database Model)
class ArticleEntity: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var content: String
    @Persisted var authorId: String
    @Persisted var authorName: String
    @Persisted var publishedAt: Date
    @Persisted var imageURL: String?
    @Persisted var cachedAt: Date
    
    func toDomain() -> Article {
        Article(
            id: id,
            title: title,
            content: content,
            author: Author(id: authorId, name: authorName),
            publishedAt: publishedAt,
            imageURL: imageURL.flatMap { URL(string: $0) }
        )
    }
    
    static func from(_ article: Article) -> ArticleEntity {
        let entity = ArticleEntity()
        entity.id = article.id
        entity.title = article.title
        entity.content = article.content
        entity.authorId = article.author.id
        entity.authorName = article.author.name
        entity.publishedAt = article.publishedAt
        entity.imageURL = article.imageURL?.absoluteString
        entity.cachedAt = Date()
        return entity
    }
}

// MARK: - Cache Policy
enum CachePolicy {
    case cacheFirst(maxAge: TimeInterval)
    case networkFirst
    case cacheOnly
    case networkOnly
}

// MARK: - Repository Implementation
class ArticleRepositoryImpl: ArticleRepository {
    private let remoteDataSource: ArticleRemoteDataSource
    private let localDataSource: ArticleLocalDataSource
    private let cachePolicy: CachePolicy
    
    init(
        remoteDataSource: ArticleRemoteDataSource,
        localDataSource: ArticleLocalDataSource,
        cachePolicy: CachePolicy = .cacheFirst(maxAge: 300)
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.cachePolicy = cachePolicy
    }
    
    func getArticle(id: String) async throws -> Article {
        switch cachePolicy {
        case .cacheFirst(let maxAge):
            // Try cache first
            if let cached = try await localDataSource.getArticle(id: id),
               Date().timeIntervalSince(cached.cachedAt) < maxAge {
                return cached.toDomain()
            }
            // Fallback to network
            let dto = try await remoteDataSource.fetchArticle(id: id)
            let article = dto.toDomain()
            try await localDataSource.saveArticle(ArticleEntity.from(article))
            return article
            
        case .networkFirst:
            do {
                let dto = try await remoteDataSource.fetchArticle(id: id)
                let article = dto.toDomain()
                try await localDataSource.saveArticle(ArticleEntity.from(article))
                return article
            } catch {
                // Fallback to cache
                if let cached = try await localDataSource.getArticle(id: id) {
                    return cached.toDomain()
                }
                throw error
            }
            
        case .cacheOnly:
            guard let cached = try await localDataSource.getArticle(id: id) else {
                throw RepositoryError.notFound
            }
            return cached.toDomain()
            
        case .networkOnly:
            let dto = try await remoteDataSource.fetchArticle(id: id)
            return dto.toDomain()
        }
    }
    
    func getArticles(page: Int, limit: Int) async throws -> [Article] {
        switch cachePolicy {
        case .cacheFirst(let maxAge):
            let cached = try await localDataSource.getArticles()
            if !cached.isEmpty && Date().timeIntervalSince(cached[0].cachedAt) < maxAge {
                return cached.map { $0.toDomain() }
            }
            fallthrough
            
        default:
            let dtos = try await remoteDataSource.fetchArticles(page: page, limit: limit)
            let articles = dtos.map { $0.toDomain() }
            let entities = articles.map { ArticleEntity.from($0) }
            try await localDataSource.saveArticles(entities)
            return articles
        }
    }
    
    func searchArticles(query: String) async throws -> [Article] {
        let dtos = try await remoteDataSource.searchArticles(query: query)
        return dtos.map { $0.toDomain() }
    }
    
    func saveArticle(_ article: Article) async throws {
        try await localDataSource.saveArticle(ArticleEntity.from(article))
    }
    
    func deleteArticle(id: String) async throws {
        try await localDataSource.deleteArticle(id: id)
    }
    
    func observeArticle(id: String) -> AsyncStream<Article> {
        AsyncStream { continuation in
            Task {
                for await entity in localDataSource.observeArticle(id: id) {
                    if let entity = entity {
                        continuation.yield(entity.toDomain())
                    }
                }
                continuation.finish()
            }
        }
    }
}

enum RepositoryError: Error {
    case notFound
    case invalidData
    case networkError
}

// MARK: - Usage
class ArticleListViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let repository: ArticleRepository
    
    init(repository: ArticleRepository) {
        self.repository = repository
    }
    
    func loadArticles() async {
        isLoading = true
        
        do {
            articles = try await repository.getArticles(page: 1, limit: 20)
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
}
```

## When to Use ✅

- Multiple data sources
- Need offline support
- Want single source of truth
- Hide data layer complexity

## When NOT to Use ❌

- Single simple data source
- No caching needs
- Over-engineering simple apps

## Related Patterns

- **Unit of Work**: Group operations
- **Data Mapper**: Map between layers
- **Facade**: Simplify data access
