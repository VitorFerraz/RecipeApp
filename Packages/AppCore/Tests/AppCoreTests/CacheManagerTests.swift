import XCTest
@testable import AppCore

final class CacheManagerTests: XCTestCase {
    func test_loadObject_whenCacheAvailable_returnsObject() async throws {
        // Given
        let (sut, dependencies) = makeSUT()
        
        let cacheKey = "TestKey"
        let object = "TestObject"
        let encoder = sut.encoder
        let cacheData = try encoder.encode(object)
        dependencies.cacheMock.set(cacheKey, cacheData)
        
        // When
        let loadedObject: String? = try sut.loadObject(cacheKey)
        
        // Then
        XCTAssertEqual(loadedObject, object)
        XCTAssertTrue(dependencies.cacheMock.getMethodCalled)
        XCTAssertEqual(dependencies.cacheMock.getMethodCallCount, 1)
        XCTAssertEqual(dependencies.cacheMock.getMethodCalledWithKey, cacheKey)
    }
    
    func test_loadObject_whenNotInCache_returnNil() async throws {
        // Given
        let (sut, dependencies) = makeSUT()
        let cacheKey = "TestKey"
        
        // When
        let loadedObject: String? = try sut.loadObject(cacheKey)
        
        // Then
        XCTAssertNil(loadedObject)
        XCTAssertTrue(dependencies.cacheMock.getMethodCalled)
        XCTAssertEqual(dependencies.cacheMock.getMethodCallCount, 1)
        XCTAssertEqual(dependencies.cacheMock.getMethodCalledWithKey, cacheKey)
    }
    
    func test_storeObject_whenSuccessfullyStoredInCache_returnObject()  async throws {
        // Given
        let (sut, dependencies) = makeSUT()
        
        let cacheKey = "TestKey"
        let object = "TestObject"
        
        // When
        let storedObject = await sut.storeObject(object, key: cacheKey)
        
        // Then
        XCTAssertEqual(storedObject, object)
        XCTAssertTrue(dependencies.cacheMock.setMethodCalled)
        XCTAssertEqual(dependencies.cacheMock.setMethodCallCount, 1)
        XCTAssertEqual(dependencies.cacheMock.setMethodCalledWithKey, cacheKey)
    }
}

extension CacheManagerTests {
    func makeSUT() -> (sut: CacheManager, dependenceis: TestDependencies) {
        let dependencies = TestDependencies()
        
        let sut = CacheManager(cache: dependencies.cacheMock)
        
        return (sut, dependencies)
    }
    
    struct TestDependencies {
        let cacheMock = CacheMock()
    }
}
