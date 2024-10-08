import SwiftUI
import Combine
import Photos

final class ImageManager {
    static let shared = ImageManager()
    private lazy var imageCache = NSCache<NSString, UIImage>()
    
    private let queue = DispatchQueue(label: "ImageDataManagerQueue")
    private let downloadSession: URLSession = .shared
    
    private init() {}
    
    func download(url: URL?) async throws -> Image {
        
        guard let url = url else { throw URLError(.badURL) }
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            return Image(uiImage: cachedImage)
        }
    
        let data = (try await downloadSession.data(from: url)).0
        
        guard let image = UIImage(data: data) else { throw URLError(.badServerResponse) }
            queue.async { self.imageCache.setObject(image, forKey: url.absoluteString as NSString) }
    
        return Image(uiImage: image)
    }
}
