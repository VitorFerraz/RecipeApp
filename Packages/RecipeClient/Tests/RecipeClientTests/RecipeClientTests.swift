import XCTest
@testable import RecipeClient

final class RecipeClientTests: XCTestCase {
    func test_fectchRecipes_returnsData() async throws {
        // Given
        let (sut, dependenceis) = makeSUT()
        let expectedURL = URL.getRecipeURL
        let expectedResponse: [RecipesDTO] = [.fixture]
        let expectedData = try dependenceis.encoder.encode(RecipeResponse.GetRecipes(recipes: expectedResponse))
        dependenceis.networkClientMock.expectedResponse = expectedData
        
        // When
        let result = try await sut.fetchRecipes()
        
        // Then
        XCTAssertEqual(result, expectedResponse)
        XCTAssertEqual(dependenceis.networkClientMock.fetchCallCount, 1)
        XCTAssertEqual(dependenceis.networkClientMock.fetchURLs.first, expectedURL)
    }
    
    func test_fectchRecipes_optionalData_returnsData() async throws {
        // Given
        let (sut, dependenceis) = makeSUT()
        let expectedURL = URL.getRecipeURL
        let expectedResponse: [RecipesDTO] = [.incompleteObjectFixture]
        let expectedData = try dependenceis.encoder.encode(RecipeResponse.GetRecipes(recipes: expectedResponse))
        dependenceis.networkClientMock.expectedResponse = expectedData
        
        // When
        let result = try await sut.fetchRecipes()
        
        // Then
        XCTAssertEqual(result, expectedResponse)
        XCTAssertEqual(dependenceis.networkClientMock.fetchCallCount, 1)
        XCTAssertEqual(dependenceis.networkClientMock.fetchURLs.first, expectedURL)
    }
    
    func test_fectchRecipes_emptyListData_returnsData() async throws {
        // Given
        let (sut, dependenceis) = makeSUT()
        let expectedURL = URL.getRecipeURL
        let expectedResponse: [RecipesDTO] = []
        let expectedData = try dependenceis.encoder.encode(RecipeResponse.GetRecipes(recipes: expectedResponse))
        dependenceis.networkClientMock.expectedResponse = expectedData
        
        // When
        let result = try await sut.fetchRecipes()
        
        // Then
        XCTAssertEqual(result, expectedResponse)
        XCTAssertEqual(dependenceis.networkClientMock.fetchCallCount, 1)
        XCTAssertEqual(dependenceis.networkClientMock.fetchURLs.first, expectedURL)
    }
}

extension RecipeClientTests {
    func makeSUT() -> (sut: RecipeClient, dependenceis: TestDependencies) {
        let dependencies = TestDependencies()
        
        let client = RecipeClient(networkClient: dependencies.networkClientMock)
        
        return (client, dependencies)
    }
    
    struct TestDependencies {
        let networkClientMock = NetworkClientMock()
        let encoder = JSONEncoder()
    }
}

extension URL {
    static var getRecipeURL: URL {
        URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
    }
}
extension RecipesDTO {
    static var fixture: Self {
        .init(
            cuisine: "Malaysian",
            name: "Apam Balik",
            photoUrlLarge: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")!,
            photoUrlSmall: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!,
            sourceUrl: URL(string: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")!,
            uuid: UUID(uuidString: "0c6ca6e7-e32a-4053-b824-1dbf749910d8")!,
            youtubeUrl: URL(string: "https://www.youtube.com/watch?v=6R8ffRRJcrg")!
        )
    }
    
    static var incompleteObjectFixture: Self {
        .init(
            cuisine: "Malaysian",
            name: "Apam Balik",
            photoUrlLarge: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")!,
            photoUrlSmall: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!,
            sourceUrl: nil,
            uuid: UUID(uuidString: "0c6ca6e7-e32a-4053-b824-1dbf749910d8")!,
            youtubeUrl: nil
        )
    }
}
