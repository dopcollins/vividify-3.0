//
//  CropController.swift
//  vividify 3.0
//
//  Created by Collins Roy on 20/08/25.
//

import Foundation
import UIKit
import TOCropViewController
import Combine

class CropController: NSObject, ObservableObject, TOCropViewControllerDelegate {
    @Published var croppedImage: UIImage?
    @Published var isProcessing = false
    
    private var completion: ((UIImage?) -> Void)?

    func createCropViewController(for image: UIImage, completion: @escaping (UIImage?) -> Void) -> TOCropViewController {
        self.completion = completion
        let cropViewController = TOCropViewController(image: image)
        cropViewController.delegate = self
        return cropViewController
    }

    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.croppedImage = image
            self?.completion?(image)
            cropViewController.dismiss(animated: true)
        }
    }

    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        completion?(nil)
        cropViewController.dismiss(animated: true)
    }
}
