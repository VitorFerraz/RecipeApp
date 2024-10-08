import Foundation
import RecipeClient

public struct RepositoryFactory {
    static public func make() -> RecipeRepositoryProtocol {
        RecipeRepository(
            recipeClient: RecipeClientFactory.make(),
            cacheManager: CacheManagerFactory.make()
        )
    }
}
