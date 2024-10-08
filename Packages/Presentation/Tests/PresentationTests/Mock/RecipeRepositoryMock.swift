import Foundation
import AppCore

final class RecipeRepositoryMock: RecipeRepositoryProtocol {
    var result: [Recipe]?
    var error: Error?
    var loadRecipesCount: Int = 0
    
    func loadRecipes() async throws -> [Recipe] {
        loadRecipesCount += 1
        if let result {
            return result
        }
        
        if let error {
            throw error
        }
        
        throw NSError(domain: "RecipeRepositoryMock.result.missing", code: -1)
    }
}
