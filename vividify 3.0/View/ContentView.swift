//import SwiftUI

import SwiftUICore
import SwiftUI

struct ContentView: View {
    @StateObject private var model = ImageEditModel()
    @State private var isAddScreen = true
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if model.selectedImage != nil {
                    ImageEditorScreen()
                        .environmentObject(model)
                } else if isAddScreen {
                    AddImageScreen()
                        .environmentObject(model)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("VIVIDIFY")
                        .font(.title2.bold())
                        .foregroundColor(.primary)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    if !isAddScreen && model.selectedImage != nil {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isAddScreen = true
                                model.clearImage()
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    }
                }
                
               
            }
            .onChange(of: model.selectedImage) { _, newValue in
                withAnimation(.easeInOut(duration: 0.3)) {
                    isAddScreen = (newValue == nil)
                }
            }
            .alert("Save Result", isPresented: $model.showingSaveAlert) {
                Button("OK") { }
            } message: {
                Text(model.saveSuccess ? "Image saved successfully!" : "Failed to save image")
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
