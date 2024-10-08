import SwiftUI
import AppCore

struct ReceipeItem: View {
    private let recipe: Recipe
    
    public init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    var body: some View {
        HStack {
            ReceipeImage(imageURL: recipe.photoUrlLarge)
                .frame(width: 100, height: 100)
            VStack(alignment: .leading) {
                Text(recipe.name)
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}
