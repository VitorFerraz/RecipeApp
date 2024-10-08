import Foundation
import AppCore
import Commons
import SwiftUI

public enum RecipesList {}

extension RecipesList {
    public final class DataModel: ObservableObject {
        private var repository: RecipeRepositoryProtocol
        @Published var recipes: [Recipe] = []
        @Published var isLoading = false
        @Published var error: Error?
        
        public init(repository: RecipeRepositoryProtocol) {
            self.repository = repository
        }
        
        func fetchRecipes() async {
            defer {
                isLoading = false
            }
            
            isLoading = true
            do {
                let recipes = try await repository.loadRecipes()
                self.recipes = recipes
            } catch {
                self.error = error
            }
        }
        
        func dismissError() {
            self.error = nil
        }
    }
}

extension RecipesList {
    public struct ContentView: View {
        @ObservedObject var dataModel: DataModel
        
        public init(
            dataModel: DataModel
        ) {
            self.dataModel = dataModel
        }
        
        public var body: some View {
            recipesContent.task {
                Task { @MainActor in
                    await dataModel.fetchRecipes()
                }
            }
            .overlay {
                if dataModel.isLoading {
                    ProgressView()
                }
            }
            .alert(
                "Ooops, something went wrong",
                isPresented: Binding(
                    get: { dataModel.error != nil },
                    set: { if !$0 { dataModel.error = nil } }
                ),
                presenting: self.dataModel.error,
                actions: { error in
                    Button("Retry") {
                        Task { @MainActor in
                            await dataModel.fetchRecipes()
                        }
                    }
                    
                    Button("Cancel", role: .cancel) {
                        self.dataModel.dismissError()
                    }
                })
            .refreshable {
                Task { @MainActor in
                    await dataModel.fetchRecipes()
                }
            }
        }
        
        @ViewBuilder
        var recipesContent: some View {
            List {
                ForEach(dataModel.recipes, id: \.id) { recipe in
                    ReceipeItem(recipe: recipe)
                }
            }.overlay {
                if dataModel.recipes.isEmpty {
                    Text("Oops, looks like that no recipes are available.")
                }
            }
        }
    }
}

#Preview {
    RecipesList.ContentView(
        dataModel: .init(
            repository: RepositoryFactory.make()
        )
    )
}
