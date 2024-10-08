import Foundation

public protocol CacheManagerProtocol {
    var cache: CacheProtocol { get }
    func loadObject<T: Codable>(_ key: String) throws -> T?
    func storeObject<T: Codable>(_ obj: T, key: String) async -> T?
}
