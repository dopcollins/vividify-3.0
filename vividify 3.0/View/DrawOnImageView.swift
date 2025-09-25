////
////  DrawOnImageView.swift
////  vividify 3.0
////
////  Created by Collins Roy on 20/08/25.
////
//
//
//import SwiftUI
//import PencilKit
//
//struct DrawOnImageView: View {
//    @Binding var selectedImage: UIImage?
//    @State private var canvasView = PKCanvasView()
//    @State private var isToolPickerVisible = true
//    @State private var imageFrame: CGRect = .zero
//    @Environment(\.dismiss) var dismiss
//
//    var body: some View {
//        VStack(spacing: 0) {
//            GeometryReader { geometry in
//                ZStack {
//                    if let image = selectedImage {
//                        Image(uiImage: image)
//                            .resizable()
//                            .scaledToFit()
//                            .background(
//                                GeometryReader { imageGeo in
//                                    Color.clear.onAppear {
//                                        DispatchQueue.main.async {
//                                            updateCanvasSize(imageSize: image.size, displaySize: imageGeo.size)
//                                        }
//                                    }
//                                }
//                            )
//                    }
//                    CanvasView(canvas: $canvasView, isToolPickerVisible: $isToolPickerVisible)
//                        .frame(width: imageFrame.width, height: imageFrame.height)
//                        .background(Color.clear)
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//            }
//            .padding(.top, 10)
//
//            
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack {
//                    Spacer()
//                    toolButton(systemImage: "trash", action: { canvasView.drawing = PKDrawing() })
//                    Spacer()
//                    toolButton(systemImage: isToolPickerVisible ? "pencil.slash" : "pencil") {
//                        isToolPickerVisible.toggle()
//                    }
//                    Spacer()
//                    toolButton(systemImage: "xmark", action: { dismiss() })
//                    Spacer()
//                    toolButton(systemImage: "checkmark", action: {
//                        saveDrawingToImage()
//                        dismiss()
//                    })
//                    Spacer()
//                }
//
////                HStack(spacing: 12) {
//////                    toolButton(systemImage: "arrow.uturn.left", action: {
//////                        canvasView.undoManager?.undo()
//////                    })
//////                    .disabled(!(canvasView.undoManager?.canUndo ?? false))
////
////
////                    toolButton(systemImage: "trash", action: {
////                        canvasView.drawing = PKDrawing()
////                    })
////
////                    toolButton(systemImage: isToolPickerVisible ? "pencil.slash" : "pencil", action: {
////                        isToolPickerVisible.toggle()
////                    })
////
////                    Spacer()
////
////                    toolButton(systemImage: "xmark", action: {
////                        dismiss()
////                    })
////
////                    toolButton(systemImage: "checkmark", action: {
////                        saveDrawingToImage()
////                        dismiss()
////                    })
////                }
//                .padding(.horizontal, 15)
//                .padding(.vertical, 10)
//                .background(
//                    RoundedRectangle(cornerRadius: 12)
//                        .fill(Color(.systemBackground))
//                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
//                )
//                .padding(.horizontal, 10)
//                .padding(.bottom, 80)
//            }
//        }
//        .navigationTitle("Draw on Image")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//
//    private func updateCanvasSize(imageSize: CGSize, displaySize: CGSize) {
//        let aspectRatio = imageSize.width / imageSize.height
//        let newWidth = min(displaySize.width, displaySize.height * aspectRatio)
//        let newHeight = newWidth / aspectRatio
//        imageFrame = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
//        canvasView.frame = imageFrame
//        canvasView.bounds = imageFrame
//    }
//
//    private func saveDrawingToImage() {
//        guard let originalImage = selectedImage else { return }
//        let imageSize = originalImage.size
//        let scaleFactor = imageSize.width / imageFrame.width
//
//        let renderer = UIGraphicsImageRenderer(size: imageSize)
//        let newImage = renderer.image { context in
//            originalImage.draw(in: CGRect(origin: .zero, size: imageSize))
//            let drawingImage = canvasView.drawing.image(from: canvasView.bounds, scale: scaleFactor)
//            drawingImage.draw(in: CGRect(origin: .zero, size: imageSize))
//        }
//
//        selectedImage = newImage
//        canvasView.drawing = PKDrawing()
//    }
//
//    private func toolButton(systemImage: String, action: @escaping () -> Void) -> some View {
//        Button(action: {
//            withAnimation(.easeInOut(duration: 0.2)) {
//                action()
//            }
//            UIImpactFeedbackGenerator(style: .light).impactOccurred()
//        }) {
//            Image(systemName: systemImage)
//                .font(.system(size: 20, weight: .medium))
//                .frame(width: 44, height: 44)
//                .foregroundColor(.primary)
//                .background(
//                    Circle()
//                        .fill(Color.gray.opacity(0.2))
//                        .shadow(radius: 2)
//                )
//        }
//    }
//}
//
//
//struct CanvasView: UIViewRepresentable {
//    @Binding var canvas: PKCanvasView
//    @Binding var isToolPickerVisible: Bool
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func makeUIView(context: Context) -> PKCanvasView {
//        canvas.drawingPolicy = .anyInput
//        canvas.isOpaque = false
//        canvas.backgroundColor = .clear
//        canvas.tool = PKInkingTool(.pen, color: .black, width: 5)
//        context.coordinator.setupToolPicker(for: canvas)
//        return canvas
//    }
//
//    func updateUIView(_ uiView: PKCanvasView, context: Context) {
//        context.coordinator.updateToolPickerVisibility(isVisible: isToolPickerVisible, for: uiView)
//    }
//
//    class Coordinator {
//        private let parent: CanvasView
//        private let toolPicker: PKToolPicker
//
//        init(_ parent: CanvasView) {
//            self.parent = parent
//            if #available(iOS 14.0, *) {
//                self.toolPicker = PKToolPicker()
//            } else {
//                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                   let window = windowScene.windows.first {
//                    guard let picker = PKToolPicker.shared(for: window) else {
//                        fatalError("Unable to create PKToolPicker: No tool picker available for the window.")
//                    }
//                    self.toolPicker = picker
//                } else {
//                    fatalError("No window found to initialize PKToolPicker.")
//                }
//            }
//        }
//
//        func setupToolPicker(for canvas: PKCanvasView) {
//            if #available(iOS 14.0, *) {
//                toolPicker.addObserver(canvas)
//            }
//            toolPicker.setVisible(parent.isToolPickerVisible, forFirstResponder: canvas)
//            if parent.isToolPickerVisible {
//                canvas.becomeFirstResponder()
//            }
//        }
//
//        func updateToolPickerVisibility(isVisible: Bool, for canvas: PKCanvasView) {
//            toolPicker.setVisible(isVisible, forFirstResponder: canvas)
//            if isVisible {
//                canvas.becomeFirstResponder()
//            }
//        }
//
//        deinit {
//            if #available(iOS 14.0, *) {
//                toolPicker.removeObserver(parent.canvas)
//            }
//        }
//    }
//}
import SwiftUI
import PencilKit

struct DrawOnImageView: View {
    @Binding var selectedImage: UIImage?
    @State private var canvasView = PKCanvasView()
    @State private var isToolPickerVisible = true
    @State private var imageFrame: CGRect = .zero
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // Image and Canvas Area
            GeometryReader { geometry in
                VStack {
                    ZStack {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(Color.white.opacity(0.20), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.10), radius: 5, x: 0, y: 2)
                                .background(
                                    GeometryReader { imageGeo in
                                        Color.clear.onAppear {
                                            DispatchQueue.main.async {
                                                updateCanvasSize(imageSize: image.size, displaySize: imageGeo.size)
                                            }
                                        }
                                    }
                                )
                        }
                        
                        CanvasView(canvas: $canvasView, isToolPickerVisible: $isToolPickerVisible)
                            .frame(width: imageFrame.width, height: imageFrame.height)
                            .background(Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Full-Width Button Controls
            VStack(spacing: 16) {
                // Primary Action Buttons Row
                HStack(spacing: 12) {
                    // Clear Drawing Button
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            canvasView.drawing = PKDrawing()
                        }
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }) {
                        liquidGlassButton(
                            title: "Clear",
                            systemImage: "trash",
                            color: .red,
                            isDestructive: true
                        )
                    }
                    
                    // Toggle Tool Picker Button
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isToolPickerVisible.toggle()
                        }
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }) {
                        liquidGlassButton(
                            title: isToolPickerVisible ? "Hide Tools" : "Show Tools",
                            systemImage: isToolPickerVisible ? "pencil.slash" : "pencil",
                            color: .blue,
                            isDestructive: false
                        )
                    }
                }
                
                // Secondary Action Buttons Row
                HStack(spacing: 12) {
                    // Cancel Button
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            dismiss()
                        }
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }) {
                        liquidGlassButton(
                            title: "Cancel",
                            systemImage: "xmark",
                            color: .secondary,
                            isDestructive: false
                        )
                    }
                    
                    // Save Button
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            saveDrawingToImage()
                            dismiss()
                        }
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }) {
                        liquidGlassButton(
                            title: "Save Drawing",
                            systemImage: "checkmark.circle.fill",
                            color: .green,
                            isDestructive: false,
                            isPrimary: true
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 25)
            .background(
                // Liquid-Glass Container
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
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color(.systemGray6).opacity(0.3)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .navigationTitle("Draw on Image")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func updateCanvasSize(imageSize: CGSize, displaySize: CGSize) {
        let aspectRatio = imageSize.width / imageSize.height
        let newWidth = min(displaySize.width, displaySize.height * aspectRatio)
        let newHeight = newWidth / aspectRatio
        imageFrame = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
        canvasView.frame = imageFrame
        canvasView.bounds = imageFrame
    }

    private func saveDrawingToImage() {
        guard let originalImage = selectedImage else { return }
        let imageSize = originalImage.size
        let scaleFactor = imageSize.width / imageFrame.width

        let renderer = UIGraphicsImageRenderer(size: imageSize)
        let newImage = renderer.image { context in
            originalImage.draw(in: CGRect(origin: .zero, size: imageSize))
            let drawingImage = canvasView.drawing.image(from: canvasView.bounds, scale: scaleFactor)
            drawingImage.draw(in: CGRect(origin: .zero, size: imageSize))
        }

        selectedImage = newImage
        canvasView.drawing = PKDrawing()
    }

    // MARK: - Liquid Glass Button Component
    
    private func liquidGlassButton(
        title: String,
        systemImage: String,
        color: Color,
        isDestructive: Bool = false,
        isPrimary: Bool = false
    ) -> some View {
        HStack(spacing: 12) {
            // Icon with glass background
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .medium))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(isPrimary ? .white : color)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                        .overlay(
                            Circle()
                                .strokeBorder(color.opacity(0.3), lineWidth: 0.5)
                        )
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                )
            
            // Title
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundColor(isPrimary ? .white : .primary)
                .multilineTextAlignment(.center)
                .lineLimit(1)
            
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
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
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                )
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
        )
        .overlay(
            // Add primary button styling as overlay if needed
            isPrimary ?
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [color.opacity(0.9), color.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
            : nil
        )
        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct CanvasView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @Binding var isToolPickerVisible: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        canvas.isOpaque = false
        canvas.backgroundColor = .clear
        canvas.tool = PKInkingTool(.pen, color: .black, width: 5)
        context.coordinator.setupToolPicker(for: canvas)
        return canvas
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        context.coordinator.updateToolPickerVisibility(isVisible: isToolPickerVisible, for: uiView)
    }

    class Coordinator {
        private let parent: CanvasView
        private let toolPicker: PKToolPicker

        init(_ parent: CanvasView) {
            self.parent = parent
            if #available(iOS 14.0, *) {
                self.toolPicker = PKToolPicker()
            } else {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    guard let picker = PKToolPicker.shared(for: window) else {
                        fatalError("Unable to create PKToolPicker: No tool picker available for the window.")
                    }
                    self.toolPicker = picker
                } else {
                    fatalError("No window found to initialize PKToolPicker.")
                }
            }
        }

        func setupToolPicker(for canvas: PKCanvasView) {
            if #available(iOS 14.0, *) {
                toolPicker.addObserver(canvas)
            }
            toolPicker.setVisible(parent.isToolPickerVisible, forFirstResponder: canvas)
            if parent.isToolPickerVisible {
                canvas.becomeFirstResponder()
            }
        }

        func updateToolPickerVisibility(isVisible: Bool, for canvas: PKCanvasView) {
            toolPicker.setVisible(isVisible, forFirstResponder: canvas)
            if isVisible {
                canvas.becomeFirstResponder()
            }
        }

        deinit {
            if #available(iOS 14.0, *) {
                toolPicker.removeObserver(parent.canvas)
            }
        }
    }
}
