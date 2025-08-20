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
                Button("Adjust Details") {
                    showingSliders.toggle()
                }
                .padding()
            }
        }
        .navigationBarItems(trailing: Button("Apply") {
            self.image = controller.applyFilters(to: image)
            presentationMode.wrappedValue.dismiss()
        })
        .sheet(isPresented: $showingSliders) {
            VStack {
                
                ScrollView {
                    VStack(alignment: .leading) {
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
                }
                
                HStack {
                    Button("Close") {
                        showingSliders = false
                    }
                    .padding()
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .frame(height: UIScreen.main.bounds.height / 3)
            .presentationDetents([.fraction(0.4)])
        }
    }
}
