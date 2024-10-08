import Foundation

struct RecipeResponse {
    struct GetRecipes: Decodable {
        let recipes: [RecipesDTO]
    }
}
