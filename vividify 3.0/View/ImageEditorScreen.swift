//
//  ImageEditorScreen.swift
//  vividify 3.0
//
//  Created by Collins Roy on 20/08/25.
//

import SwiftUICore
import SwiftUI


// ImageEditorScreen.swift
struct ImageEditorScreen: View {
    @EnvironmentObject var model: ImageEditModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Image Display Area
            GeometryReader { geometry in
                if let image = model.processedImage ?? model.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                } else {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .background(Color.black.opacity(0.05))
            .overlay(
                model.isProcessing ? 
                ProgressView("Processing...")
                    .padding()
                    .background(Color(.systemBackground).opacity(0.9))
                    .cornerRadius(10)
                : nil
            )
            
            // Tools Section
            VStack(spacing: 16) {
                // Tools Navigation
                NavigationLink(destination: ToolsView(selectedImage: $model.selectedImage)
                    .environmentObject(model)) {
                    HStack {
                        Image(systemName: "wrench.and.screwdriver")
                        Text("Edit Tools")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .padding(.horizontal, 20)
                    .foregroundColor(.primary)
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
                }
                
                // Export Button
                Button(action: {
                    saveImageToGallery()
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Save to Photos")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .padding(.horizontal, 20)
                    .foregroundColor(.primary)
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(Color(.systemGray6))
        }
    }
    
    private func saveImageToGallery() {
        guard let image = model.processedImage ?? model.selectedImage else { return }
        
        model.isProcessing = true
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            model.isProcessing = false
            model.saveSuccess = true
            model.showingSaveAlert = true
        }
    }
}
