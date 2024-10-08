import Foundation

enum ReceipesEndpoint {
    case getReceipes
    
    var path: String {
        switch self {
        case .getReceipes:
            return "/recipes.json"
        }
    }
}
