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
        ZStack {
            if let adjustedImage = controller.model.adjustedImage {
                Image(uiImage: adjustedImage)
                    .resizable()
                    .scaledToFit()
                    .edgesIgnoringSafeArea(.all)
                    .padding(8)
            } else {
                Text("Loading image...")
                    .foregroundColor(.secondary)
                    .font(.headline)
            }
            
            VStack {
                Spacer()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Gaussian Blur")
                        Slider(value: $controller.model.smoothness, in: 0...2, onEditingChanged: { _ in
                            controller.applyFilters()
                        })
                        
                        Text("Sharpness")
                        Slider(value: $controller.model.sharpness, in: 0...2, onEditingChanged: { _ in
                            controller.applyFilters()
                        })
                    }
                    .padding()
                }
                .frame(height: UIScreen.main.bounds.height / 4)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .padding()
            }
            .navigationBarItems(trailing: Button("Apply") {
                image = controller.model.adjustedImage
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
