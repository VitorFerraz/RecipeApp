import Foundation
import Commons

public protocol NetworkClientProtocol {
    func fetch(url: URL) async throws -> Data
}

public struct NetworkClient: NetworkClientProtocol, Loggable {
    private let session: URLSessionProtocol
    
    public init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    public func fetch(url: URL) async throws -> Data {
        log("fetching data form: \(url)")
        let (data, _) = try await session.data(from: url)
        return data
    }
}
