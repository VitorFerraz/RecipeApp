import Foundation

public protocol RecipeClientProtocol {
    func fetchRecipes() async throws -> [RecipesDTO]
}
