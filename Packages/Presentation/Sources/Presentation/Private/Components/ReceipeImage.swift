import SwiftUI
struct ReceipeImage: View {
    var imageURL: URL
    
    var body: some View {
        imageView.clipShape(RoundedRectangle(cornerRadius: 8.0))
    }
    
    @ViewBuilder
    var imageView: some View {
        ImageView(url: imageURL) {
            Image(systemName: "photo.artframe")
                .font(.system(size: 40))
        }
    }
}
