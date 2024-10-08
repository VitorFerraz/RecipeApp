import Foundation
import Commons
import Network

public final class RecipeClient: RecipeClientProtocol, Loggable {
    private let decoder: JSONDecoder
    private let networkClient: NetworkClientProtocol
    
    init(
        decoder: () -> JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        },
        networkClient: NetworkClientProtocol
    ) {
        self.decoder = decoder()
        self.networkClient = networkClient
    }
    
    public func fetchRecipes() async throws -> [RecipesDTO] {
        log("fetching recipes")
        let response: RecipeResponse.GetRecipes = try await fetch(url: buildURL(for: .getReceipes))
        return response.recipes
    }
    
}

// MARK - Network Fetch Helpers
private extension RecipeClient {
    /// Fetches a decodable object from the given URL
    func fetch<T: Decodable>(url: URL) async throws -> T {
        let typeId = String(describing: T.self)
        log("type: \(typeId)")
        let data = try await networkClient.fetch(url: url)
        return try decoder.decode(T.self, from: data)
    }

    /// Builds the URL for a given endpoint
    func buildURL(for endpoint: ReceipesEndpoint) -> URL {
        URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net")!
            .appendingPathComponent(endpoint.path)
    }
}
