//
//  DetailsView.swift
//  vividify 3.0
//
//  Created by Collins Roy on 20/08/25.
//


import SwiftUI

struct DetailsView: View {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var controller = DetailsController()
    @State private var showingSliders = false
    
    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: controller.applyFilters(to: image) ?? image)
                    .resizable()
                    .scaledToFit()
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack {
                Spacer()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Brightness").foregroundColor(.black)
                        Slider(value: $controller.brightness, in: -1...1)
                        
                        Text("Contrast").foregroundColor(.black)
                        Slider(value: $controller.contrast, in: 0.5...2)
                        
                        Text("Saturation").foregroundColor(.black)
                        Slider(value: $controller.saturation, in: 0...2)
                        
                        Text("Warmth").foregroundColor(.black)
                        Slider(value: $controller.warmth, in: -1...1)
                        
                        Text("Shadows").foregroundColor(.black)
                        Slider(value: $controller.shadows, in: -1...1)
                    }
                    .padding()
                }
                .frame(height: UIScreen.main.bounds.height / 4)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .padding()
            }
            .navigationBarItems(trailing: Button("Apply") {
                self.image = controller.applyFilters(to: image)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
