import XCTest
import SwiftUI
import SnapshotTesting
@testable import Presentation
import AppCore

@MainActor
final class RecipesListSnapshotTests: XCTestCase {
    
    override func invokeTest() {
        //Used to avoid real requests for the image donwload
        PlaceholderImageTesting.$placeholderImage.withValue(.imageColor()) {
            super.invokeTest()
        }
    }
    
    func testList() async {
        // Given
        let (dataModel, dependencies) = makeDataModel()
        dependencies.repositoryMock.result = [.fixture]
        
        // When
        await dataModel.fetchRecipes()
        
        // Then
        let sut = RecipesList.ContentView(dataModel: dataModel)
        let controller = UIHostingController(rootView: sut.fixedSize(horizontal: false, vertical: false))
        controller.view.frame = UIScreen.main.bounds
        assertSnapshot(of: controller, as: .wait(for: 1, on: .image(traits: .iPhone13(.portrait))), record: false)
    }
    
    func testEmptyList() async {
        // Given
        let (dataModel, dependencies) = makeDataModel()
        dependencies.repositoryMock.result = []
        
        // When
        await dataModel.fetchRecipes()
        
        // Then
        let sut = RecipesList.ContentView(dataModel: dataModel)
        let controller = UIHostingController(rootView: sut.fixedSize(horizontal: false, vertical: false))
        controller.view.frame = UIScreen.main.bounds
        assertSnapshot(of: controller, as: .wait(for: 1, on: .image(traits: .iPhone13(.portrait))), record: false)
    }
}

extension RecipesListSnapshotTests {
    
    func makeDataModel() -> (dataModel: RecipesList.DataModel, dependenceis: TestDependencies) {
        let dependencies = TestDependencies()
        
        let client = RecipesList.DataModel(repository: dependencies.repositoryMock)
        
        return (client, dependencies)
    }
    
    struct TestDependencies {
        let repositoryMock = RecipeRepositoryMock()
    }
}
