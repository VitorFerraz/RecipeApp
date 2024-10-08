import Foundation
import Commons
import Network

public struct RecipeClientFactory {
    static public func make(networkClient: NetworkClientProtocol = NetworkClient()) -> RecipeClientProtocol {
        RecipeClient(networkClient: networkClient)
    }
}
