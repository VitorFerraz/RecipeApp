import Foundation

public protocol RecipeRepositoryProtocol: AnyObject {
    func loadRecipes() async throws -> [Recipe]
}
