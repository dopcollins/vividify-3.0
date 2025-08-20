//
//  CropView.swift
//  vividify 3.0
//
//  Created by Collins Roy on 20/08/25.
//


import Foundation
import SwiftUI
import TOCropViewController

struct CropView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var controller = CropController()

    class Coordinator: NSObject, TOCropViewControllerDelegate {
        var parent: CropView

        init(parent: CropView) {
            self.parent = parent
        }

        func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
            DispatchQueue.main.async {
                self.parent.image = image
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }

        func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
            DispatchQueue.main.async {
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> TOCropViewController {
        guard let selectedImage = image else {
            return TOCropViewController(image: UIImage())
        }
        
        let cropViewController = TOCropViewController(image: selectedImage)
        cropViewController.delegate = context.coordinator
        return cropViewController
    }

    func updateUIViewController(_ uiViewController: TOCropViewController, context: Context) {
        
    }
}
