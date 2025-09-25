//
//  ToolsView.swift
//  vividify 3.0
//
//  Created by Collins Roy on 20/08/25.
//

import SwiftUI
import UIKit

struct ToolsView: View {
    @Binding var selectedImage: UIImage?
    @State private var navigateToPolynomialAdjustment = false

    var body: some View {
        VStack(spacing: 20) {
            if let image = selectedImage {
                GeometryReader { geometry in
                    VStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: geometry.size.height * 0.7)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay(
                                // subtle edge highlight
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color.white.opacity(0.20), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.10), radius: 5, x: 0, y: 2)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    NavigationLink(destination: CropView(image: $selectedImage)) {
                        toolButton(title: "Crop", systemImage: "crop")
                    }

                    NavigationLink(destination: DetailsView(image: $selectedImage)) {
                        toolButton(title: "Details", systemImage: "slider.horizontal.3")
                    }

                    NavigationLink(destination: TuneImageView(image: $selectedImage)) {
                        toolButton(title: "Tune", systemImage: "slider.horizontal.below.square.filled.and.square")
                    }

                    NavigationLink(destination: DrawOnImageView(selectedImage: $selectedImage)) {
                        toolButton(title: "Draw", systemImage: "pencil.tip.crop.circle")
                    }
                    
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(
                    // Liquid-Glass-ish toolbar container (works on current SDKs)
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.ultraThinMaterial)
                        // soft inner sheen
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
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
                        // crisp edge + soft lift
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(Color.white.opacity(0.25), lineWidth: 0.8)
                        )
                        .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 6)
                )
                .padding(.horizontal, 15)
                .padding(.bottom, 20)
            }
        }
    }

    // MARK: - Glassy Tool Button (SDK-compatible)

    func toolButton(title: String, systemImage: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: systemImage)
                .font(.system(size: 22, weight: .medium))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.primary)

            Text(title)
                .font(.caption.bold())
                .foregroundColor(.primary)
        }
        .frame(width: 70, height: 70)
        .background(
            Circle()
                .fill(.ultraThinMaterial) // translucent base
                // specular sweep to mimic "liquid" shine
                .overlay(
                    Circle()
                        .strokeBorder(Color.white.opacity(0.28), lineWidth: 0.8)
                )
                .shadow(color: .black.opacity(0.10), radius: 4, x: 0, y: 2)
        )
        .contentShape(Circle())
        .accessibilityLabel(title)
    }
}
