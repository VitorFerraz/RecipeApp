import Foundation
import RecipeClient

struct RecipeMapper {
    static func map(dto: RecipesDTO) -> Recipe {
        Recipe(
            cuisine: dto.cuisine,
            name: dto.name,
            photoUrlLarge: dto.photoUrlLarge,
            photoUrlSmall: dto.photoUrlSmall,
            sourceUrl: dto.sourceUrl,
            id: dto.uuid,
            youtubeUrl: dto.youtubeUrl
        )
    }
}
