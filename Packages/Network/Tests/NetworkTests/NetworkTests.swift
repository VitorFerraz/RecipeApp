import XCTest
@testable import Network

final class NetworkTests: XCTestCase {
    func test_fetch_withSuccess() async throws {
        // Given
        let expectedData = Data()
        let (sut, dependencies) = makeSUT()
        dependencies.urlSessionMock.setupMock(
            data: Data(),
            response: URLResponse(),
            error: nil
        )
        
        // When
        do  {
            let response = try await sut.fetch(url: .mock)
            // Then
            XCTAssertEqual(response, expectedData)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func test_fetch_withFailure() async throws {
        // Given
        let expectedError = NSError(domain: "error", code: 404)
        let (sut, dependencies) = makeSUT()
        dependencies.urlSessionMock.setupMock(
            data: nil,
            response: nil,
            error: expectedError
        )
        
        // When
        do  {
            _ = try await sut.fetch(url: .mock)
            // Then
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)

        }
    }
}

extension NetworkTests {
    func makeSUT() -> (sut: NetworkClient, dependenceis: TestDependencies) {
        let dependencies = TestDependencies()
        
        let client = NetworkClient(session: dependencies.urlSessionMock)
        
        return (client, dependencies)
    }
    
    struct TestDependencies {
        let urlSessionMock = URLSessionMock()
    }
}
