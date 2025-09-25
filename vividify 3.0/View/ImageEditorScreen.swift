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
                VStack {
                    if let image = model.processedImage ?? model.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: geometry.size.height * 0.85)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay(
                                // subtle edge highlight matching ToolsView
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color.white.opacity(0.20), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.10), radius: 5, x: 0, y: 2)
                    } else {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.black.opacity(0.05))
                            .frame(maxHeight: geometry.size.height * 0.85)
                            .overlay(
                                ProgressView("Loading...")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color.white.opacity(0.20), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.10), radius: 5, x: 0, y: 2)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(
                    // Processing overlay with liquid-glass style
                    model.isProcessing ?
                    VStack(spacing: 12) {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text("Processing...")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.35),
                                                Color.white.opacity(0.05)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .blendMode(.plusLighter)
                                    .opacity(0.45)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.white.opacity(0.25), lineWidth: 0.8)
                            )
                            .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 8)
                    )
                    : nil
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Tools Section with Liquid-Glass Container
            VStack(spacing: 20) {
                // Edit Tools Button
                NavigationLink(destination: ToolsView(selectedImage: $model.selectedImage)
                    .environmentObject(model)) {
                    liquidGlassButton(
                        title: "Edit Tools",
                        systemImage: "wrench.and.screwdriver",
                        showChevron: true
                    )
                }
                
                // Save Button
                Button(action: {
                    saveImageToGallery()
                }) {
                    liquidGlassButton(
                        title: "Save to Photos",
                        systemImage: "square.and.arrow.up",
                        showChevron: false
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 25)
            .background(
                // Matching the ToolsView container style
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.35),
                                        Color.white.opacity(0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .blendMode(.plusLighter)
                            .opacity(0.45)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .stroke(Color.white.opacity(0.25), lineWidth: 0.8)
                    )
                    .shadow(color: .black.opacity(0.12), radius: 15, x: 0, y: 8)
            )
            .padding(.horizontal, 15)
            .padding(.bottom, 20)
        }
        .background(
            // Subtle background gradient
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color(.systemGray6).opacity(0.3)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    // MARK: - Liquid Glass Button Component
    
    func liquidGlassButton(title: String, systemImage: String, showChevron: Bool) -> some View {
        HStack(spacing: 16) {
            // Icon with subtle background
            Image(systemName: systemImage)
                .font(.system(size: 20, weight: .medium))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.primary)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                        .overlay(
                            Circle()
                                .strokeBorder(Color.white.opacity(0.28), lineWidth: 0.5)
                        )
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                )
            
            // Title
            Text(title)
                .font(.headline.weight(.medium))
                .foregroundColor(.primary)
            
            Spacer()
            
            // Chevron (if needed)
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                    .frame(width: 24, height: 24)
                    .background(
                        Circle()
                            .fill(Color.primary.opacity(0.05))
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.25),
                                    Color.white.opacity(0.02)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .blendMode(.plusLighter)
                        .opacity(0.6)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                )
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
        .contentShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
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
