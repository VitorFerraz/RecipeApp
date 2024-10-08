import Foundation
@testable import RecipeClient

extension RecipeResponse.GetRecipes: Encodable {
    enum CodingKeys: String, CodingKey {
        case recipes
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(recipes, forKey: .recipes)
    }
}

extension RecipesDTO: Encodable {
    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoUrlLarge
        case photoUrlSmall
        case sourceUrl
        case uuid
        case youtubeUrl
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cuisine, forKey: .cuisine)
        try container.encode(name, forKey: .name)
        try container.encode(photoUrlLarge, forKey: .photoUrlLarge)
        try container.encode(photoUrlSmall, forKey: .photoUrlSmall)
        try container.encode(sourceUrl, forKey: .sourceUrl)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(youtubeUrl, forKey: .youtubeUrl)
    }
}
