import Foundation
import AppCore

class CacheManagerMock: CacheManagerProtocol {
    var loadCalled: Bool = false
    var storeCalled: Bool = false
    var loadCalledWithKey: String?
    var storeCalledWithKey: String?
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()

    var cache: CacheProtocol

    init(cache: CacheProtocol) {
        self.cache = cache
    }

    func loadObject<T: Codable>(_ key: String) throws -> T? {
        loadCalled = true
        loadCalledWithKey = key
        if let data = cache.get(key) {
            return try decoder.decode(T.self, from: data)
        }
        return nil
    }

    func storeObject<T: Codable>(_ obj: T, key: String) async -> T? {
        storeCalled = true
        storeCalledWithKey = key
        if let data = try? encoder.encode(obj) {
            cache.set(key, data)
        }
        return obj
    }
}
