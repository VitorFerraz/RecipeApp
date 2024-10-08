import SwiftUI

struct ImageView<Placeholder>: View where Placeholder: View {

    @State private var image: Image? = nil
    @State private var task: Task<(), Never>? = nil
    @State private var isProgressing = false

    private let url: URL?
    private let placeholder: () -> Placeholder?


    init(url: URL?, @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.url = url
        self.placeholder = placeholder
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                placholderView
                imageView
                progressView
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .onAppear {
                if let placeholderImage = PlaceholderImageTesting.placeholderImage {
                    isProgressing = false
                    self.image = placeholderImage
                    return
                }
            }
            .task {
                if PlaceholderImageTesting.placeholderImage == nil {
                    task?.cancel()
                    task = Task.detached(priority: .background) {
                        await MainActor.run { isProgressing = true }
                    
                        do {
                            let image = try await ImageManager.shared.download(url: url)
                        
                            await MainActor.run {
                                isProgressing = false
                                self.image = image
                            }
                        
                        } catch {
                            await MainActor.run { isProgressing = false }
                        }
                    }
                }
            }
            .onDisappear {
                task?.cancel()
            }
        }
    }
    
    @ViewBuilder
    private var imageView: some View {
        if let image = image {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .transition(.scale(scale: 0.1, anchor: .center))
        }
    }

    @ViewBuilder
    private var placholderView: some View {
        if !isProgressing, image == nil {
            placeholder()
        }
    }
    
    @ViewBuilder
    private var progressView: some View {
        if isProgressing {
            ProgressView()
                .progressViewStyle(.circular)
        }
    }
}

public enum PlaceholderImageTesting {
    @TaskLocal public static var placeholderImage: Image?
}

extension Image {
    public static func imageColor(color: UIColor = .red) -> Image {
        Image(uiImage: UIImage.imageWithColor(color: color))
    }
}
              
extension UIImage {
    public class func imageWithColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 1), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

