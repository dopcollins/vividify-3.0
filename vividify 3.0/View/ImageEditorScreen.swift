//
//  ImageEditorScreen.swift
//  vividify 3.0
//
//  Created by Collins Roy on 20/08/25.
//

import SwiftUI

struct ImageEditorScreen: View {
    @EnvironmentObject var model: ImageEditModel
    
    var body: some View {
        VStack(spacing: 0) {
            
          
            GeometryReader { geometry in
                ZStack {
                    if let image = model.processedImage ?? model.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: geometry.size.height * 0.85)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
                    } else {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .frame(maxHeight: geometry.size.height * 0.85)
                            .overlay(ProgressView("Loading..."))
                    }
                    
                   
                    if model.isProcessing {
                        VStack(spacing: 12) {
                            ProgressView()
                                .scaleEffect(1.2)
                            Text("Processing...")
                                .font(.headline)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(Color.white.opacity(0.25), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 8)
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            VStack(spacing: 20) {
                NavigationLink(destination: ToolsView(selectedImage: $model.selectedImage)
                    .environmentObject(model)) {
                    glassButton(title: "Edit Tools", systemImage: "wrench.and.screwdriver", showChevron: true)
                }
                
                Button(action: saveImageToGallery) {
                    glassButton(title: "Save to Photos", systemImage: "square.and.arrow.up", showChevron: false)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 25)
            .background(
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .stroke(Color.white.opacity(0.25), lineWidth: 0.8)
                    )
                    .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)
            )
            .padding(.horizontal, 15)
            .padding(.bottom, 20)
        }
        .background(
            LinearGradient(
                colors: [Color(.systemBackground), Color(.systemGray6).opacity(0.4)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
    
    func glassButton(title: String, systemImage: String, showChevron: Bool) -> some View {
        HStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: 20, weight: .medium))
                .frame(width: 40, height: 40)
                .background(.ultraThinMaterial, in: Circle())
            
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
            
            if showChevron {
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                )
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
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
