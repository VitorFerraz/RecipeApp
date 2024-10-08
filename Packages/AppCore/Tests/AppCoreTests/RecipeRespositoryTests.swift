import XCTest
import RecipeClient
@testable import AppCore

final class RecipeRespositoryTests: XCTestCase {
    func test_loadRecipeFromCache() async throws {
        // Given
        var (sut, dependencies) = makeSUT()
        let cacheKey = RecipeRepository.recipeListKey
        let recipes: [RecipesDTO] = [.fixture]
        let expectedRecipes: [Recipe] = [.fixture]
        
        let recipesData = try dependencies.cacheManagerMock.encoder.encode(recipes)
        dependencies.cacheMock.set(cacheKey, recipesData)
        
        // When
        let loadedRecipes = try await sut.loadRecipes()
        
        // Then
        XCTAssertEqual(loadedRecipes, expectedRecipes)
        XCTAssertTrue(dependencies.cacheManagerMock.loadCalled)
        XCTAssertEqual(dependencies.cacheManagerMock.loadCalledWithKey, cacheKey)
        XCTAssertEqual(dependencies.recipeClientMock.fetchRecipesCallCount, 0)
    }
    
    func test_loadRecipeFromNetwork() async throws {
        // Given
        var (sut, dependencies) = makeSUT()
        let recipes: [RecipesDTO] = [.fixture]
        let expectedRecipes: [Recipe] = [.fixture]
        dependencies.recipeClientMock.expectedDTO = recipes
        
        // When
        let loadedRecipes = try await sut.loadRecipes()
        
        // Then
        XCTAssertEqual(loadedRecipes, expectedRecipes)
        XCTAssertTrue(dependencies.cacheManagerMock.loadCalled)
        XCTAssertEqual(dependencies.recipeClientMock.fetchRecipesCallCount, 1)
    }
    
    func test_storeRecipesInCache() async throws {
        // Given
        var (sut, dependencies) = makeSUT()
        let cacheKey = RecipeRepository.recipeListKey
        let recipes: [RecipesDTO] = [.fixture]
        let expectedRecipes: [Recipe] = [.fixture]
        dependencies.recipeClientMock.expectedDTO = recipes
        
        // When
        let loadedRecipes = try await sut.loadRecipes()
        
        // Then
        XCTAssertEqual(loadedRecipes, expectedRecipes)
        XCTAssertTrue(dependencies.cacheManagerMock.loadCalled)
        XCTAssertEqual(dependencies.cacheManagerMock.loadCalledWithKey, cacheKey)
        XCTAssertTrue(dependencies.cacheManagerMock.storeCalled)
        XCTAssertEqual(dependencies.cacheManagerMock.storeCalledWithKey, cacheKey)
        XCTAssertEqual(dependencies.recipeClientMock.fetchRecipesCallCount, 1)
    }
    
    func test_failedNetworkRequestThrows() async throws {
        // Given
        let (sut, dependencies) = makeSUT()
        let expectedError = NSError(
            domain: "Recipes.app",
            code: 404
        )
        dependencies.recipeClientMock.expectedError = expectedError
        
        do {
            // When
            _ = try await sut.loadRecipes()
            
            // Then
            XCTFail("Expected error to be thrown")
        } catch {
            // Then
            XCTAssertEqual(error as NSError, expectedError)
            XCTAssertEqual(dependencies.recipeClientMock.fetchRecipesCallCount, 1)
        }
    }
}

extension RecipeRespositoryTests {
    func makeSUT() -> (sut: RecipeRepositoryProtocol, dependenceis: TestDependencies) {
        var dependencies = TestDependencies()
        
        let sut = RecipeRepository(
            recipeClient: dependencies.recipeClientMock,
            cacheManager: dependencies.cacheManagerMock
        )
        return (sut, dependencies)
    }
    
    struct TestDependencies {
        let cacheMock = CacheMock()
        let recipeClientMock = RecipeClientMock()
        lazy var cacheManagerMock = CacheManagerMock(cache: cacheMock)
    }
}

extension Recipe {
    static var fixture: Self {
        .init(
            cuisine: "Malaysian",
            name: "Apam Balik",
            photoUrlLarge: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")!,
            photoUrlSmall: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!,
            sourceUrl: URL(string: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")!,
            id: UUID(uuidString: "0c6ca6e7-e32a-4053-b824-1dbf749910d8")!,
            youtubeUrl: URL(string: "https://www.youtube.com/watch?v=6R8ffRRJcrg")!
        )
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
}
