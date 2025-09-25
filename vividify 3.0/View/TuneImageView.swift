import SwiftUI

struct TuneImageView: View {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var controller: TuneImageController
    
    init(image: Binding<UIImage?>) {
        _image = image
        if let img = image.wrappedValue {
            _controller = StateObject(wrappedValue: TuneImageController(image: img))
        } else {
            _controller = StateObject(wrappedValue: TuneImageController(image: UIImage()))
        }
    }
    
    var body: some View {
        VStack {
            if let adjustedImage = controller.model.adjustedImage {
                Image(uiImage: adjustedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            } else {
                Text("Loading image...")
                    .foregroundColor(.secondary)
                    .font(.headline)
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                Text("Smoothness")
                    .foregroundColor(.primary)
                Slider(value: $controller.model.smoothness, in: 0...2, onEditingChanged: { _ in
                    controller.applyFilters()
                })
                
                Text("Sharpness")
                    .foregroundColor(.primary)
                Slider(value: $controller.model.sharpness, in: 0...2, onEditingChanged: { _ in
                    controller.applyFilters()
                })
            }
            .padding()
        }
        .padding(.horizontal)
        .background(Color(UIColor.systemBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Apply") {
                    image = controller.model.adjustedImage
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}
