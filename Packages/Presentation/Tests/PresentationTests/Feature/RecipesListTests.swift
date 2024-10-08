import XCTest
import Combine
@testable import Presentation
import AppCore

final class RecipesListTests: XCTestCase {
    func test_loadRecipes_whenCalled_thenLoadRecipes() async {
        // Given
        let (sut, dependencies) = makeSUT()
        dependencies.repositoryMock.result = [.fixture]
        
        // When
        await sut.fetchRecipes()
        
        // Then
        XCTAssertEqual(sut.recipes, [.fixture])
        XCTAssertEqual(dependencies.repositoryMock.loadRecipesCount, 1)
    }
    
    func test_loadRecipes_withError_thenShowError() async {
        // Given
        let (sut, dependencies) = makeSUT()
        let error = NSError(domain: "error", code: -1)
        dependencies.repositoryMock.error = error
        
        // When
        await sut.fetchRecipes()
        
        // Then
        XCTAssertEqual(sut.error as? NSError, error)
        XCTAssertEqual(dependencies.repositoryMock.loadRecipesCount, 1)
    }
    
    func test_callDismissError_clearError() async {
        // Given
        let (sut, dependencies) = makeSUT()
        let error = NSError(domain: "error", code: -1)
        dependencies.repositoryMock.error = error
        await sut.fetchRecipes()
        XCTAssertEqual(sut.error as? NSError, error)

        // When
        sut.dismissError()
        
        // Then
        XCTAssertNil(sut.error)
        XCTAssertEqual(dependencies.repositoryMock.loadRecipesCount, 1)
    }
    
    func test_loading() async {
        // Given
        let (sut, dependencies) = makeSUT()
        var cancellables: Set<AnyCancellable> = []
        var loadState: [Bool] = []
        sut.$isLoading.sink { newValue in
            loadState.append(newValue)
        }.store(in: &cancellables)
        dependencies.repositoryMock.result = [.fixture]
        
        // When
        await sut.fetchRecipes()
        
        // Then
        // Initial State | Loading State | State after loading
        XCTAssertEqual(loadState, [false, true, false])
        XCTAssertEqual(dependencies.repositoryMock.loadRecipesCount, 1)
    }
}

extension RecipesListTests {
    func makeSUT() -> (sut: RecipesList.DataModel, dependenceis: TestDependencies) {
        let dependencies = TestDependencies()
        
        let client = RecipesList.DataModel(repository: dependencies.repositoryMock)
        
        return (client, dependencies)
    }
    
    struct TestDependencies {
        let repositoryMock = RecipeRepositoryMock()
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
