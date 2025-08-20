import SwiftUICore
import SwiftUI

struct AddImageScreen: View {
    @EnvironmentObject var model: ImageEditModel
    @State private var isPickerOptionSheetPresented = false
    
    var body: some View {
        VStack(spacing: 60) {
            Spacer()
            
            VStack(spacing: 20) {
                // Plus button
                Button(action: {
                    isPickerOptionSheetPresented.toggle()
                }) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.gray.opacity(0.7))
                }
                
                Text("Select an Image to Start Editing")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .sheet(isPresented: $isPickerOptionSheetPresented) {
            // two options
            VStack(spacing: 20) {
                Text("Select Image Source")
                    .font(.headline)
                
                Button(action: {
                    model.isGalleryPickerPresented.toggle()
                    isPickerOptionSheetPresented = false
                }) {
                    HStack {
                        Image(systemName: "photo.on.rectangle")
                        Text("Choose from Gallery")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .foregroundColor(.primary)
                    .background(Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.primary.opacity(0.3), lineWidth: 2)
                    )
                    .cornerRadius(15)
                    
                }
                
                Button(action: {
                    model.isCameraPickerPresented.toggle()
                    isPickerOptionSheetPresented = false
                }) {
                    HStack {
                        Image(systemName: "camera")
                        Text("Take Photo")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .foregroundColor(.primary)
                    .background(Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.primary.opacity(0.3), lineWidth: 2)
                    )
                    .cornerRadius(15)
                }
            }
            .padding()
        }
        
        .sheet(isPresented: $model.isGalleryPickerPresented) {
            GalleryPicker(selectedImage: $model.selectedImage)
        }
        .sheet(isPresented: $model.isCameraPickerPresented) {
            CameraPicker(selectedImage: $model.selectedImage)
        }
    }
}
