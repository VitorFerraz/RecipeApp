import Foundation

public struct Recipe: Identifiable, Hashable {
    public let cuisine: String
    public let name: String
    public let photoUrlLarge: URL
    public let photoUrlSmall: URL
    public let sourceUrl: URL?
    public let id: UUID
    public let youtubeUrl: URL?
    
    public init(
        cuisine: String,
        name: String,
        photoUrlLarge: URL,
        photoUrlSmall: URL,
        sourceUrl: URL? = nil,
        id: UUID,
        youtubeUrl: URL? = nil
    ) {
        self.cuisine = cuisine
        self.name = name
        self.photoUrlLarge = photoUrlLarge
        self.photoUrlSmall = photoUrlSmall
        self.sourceUrl = sourceUrl
        self.id = id
        self.youtubeUrl = youtubeUrl
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
