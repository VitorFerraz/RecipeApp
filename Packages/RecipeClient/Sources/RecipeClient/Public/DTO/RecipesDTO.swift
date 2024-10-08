import Foundation

public struct RecipesDTO: Codable, Equatable {
    public let cuisine: String
    public let name: String
    public let photoUrlLarge: URL
    public let photoUrlSmall: URL
    public let sourceUrl: URL?
    public let uuid: UUID
    public let youtubeUrl: URL?
    
    public init(
        cuisine: String,
        name: String,
        photoUrlLarge: URL,
        photoUrlSmall: URL,
        sourceUrl: URL? = nil,
        uuid: UUID,
        youtubeUrl: URL? = nil
    ) {
        self.cuisine = cuisine
        self.name = name
        self.photoUrlLarge = photoUrlLarge
        self.photoUrlSmall = photoUrlSmall
        self.sourceUrl = sourceUrl
        self.uuid = uuid
        self.youtubeUrl = youtubeUrl
    }
    
}
