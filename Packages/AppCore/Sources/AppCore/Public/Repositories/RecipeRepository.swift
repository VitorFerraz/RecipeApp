import Foundation
import Commons
import RecipeClient

final public class RecipeRepository: RecipeRepositoryProtocol, Loggable {
    private let recipeClient: RecipeClientProtocol
    private let cacheManager: CacheManagerProtocol?
    static var recipeListKey: String {
        "recipe_list_cache_key"
    }
    
    public init(
        recipeClient: RecipeClientProtocol,
        cacheManager: CacheManagerProtocol?
    ) {
        self.recipeClient = recipeClient
        self.cacheManager = cacheManager
    }
    
    public func loadRecipes() async throws -> [Recipe] {
        log("loading recipes")
        
        // Load from cache
        if let cached = try loadFromCache() {
            return cached
        }
        
        // Load from network
        let dto = try await loadFromNetwork()
        
        // Store in cache
        await storeInCache(dto)
        
        // Map to return
        return map(dto)
    }
}

// MARK: - Network
private extension RecipeRepository {
    func loadFromNetwork() async throws -> [RecipesDTO]  {
        try await recipeClient.fetchRecipes()
    }
}

// MARK: - Private RecipeRepository Mapper
private extension RecipeRepository {
    func map(_ list: [RecipesDTO]) -> [Recipe] {
        list.map {
            RecipeMapper.map(dto: $0)
        }
    }
}

// MARK: - Cache Handling
private extension RecipeRepository {
    func loadFromCache() throws -> [Recipe]? {
        guard let cacheManager else {
            log("cache manager not set")
            return nil
        }

        if let dto: [RecipesDTO] = try cacheManager.loadObject(Self.recipeListKey) {
            return map(dto)
        }

        return nil
    }
    
    func storeInCache(_ dto: [RecipesDTO]) async {
        _ = await cacheManager?.storeObject(dto, key: Self.recipeListKey)
    }
}
