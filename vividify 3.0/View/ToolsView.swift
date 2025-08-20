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
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(.systemBackground), style: StrokeStyle(lineWidth: 1)) 
                            )
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
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
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                )
                .padding(.horizontal, 15)
                .padding(.bottom, 20)
            }
        }
    }

    func toolButton(title: String, systemImage: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: systemImage)
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(.primary)
            Text(title)
                .font(.caption.bold())
                .foregroundColor(.primary)
        }
        .frame(width: 70, height: 70)
        .background(
            Circle()
                .fill(Color.gray.opacity(0.15))
                .shadow(radius: 3)
        )
        .overlay(
            Circle()
                .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 1))
        )
        .scaleEffect(1.0)
        .contentShape(Circle())
        .accessibilityLabel(title)
    }
}
