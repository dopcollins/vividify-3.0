//
//  ImageProcessor.swift
//  vividify 3.0
//
//  Created by Collins Roy on 20/08/25.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class ImageProcessor {
    static let shared = ImageProcessor()
    private let context: CIContext
    private let processingQueue = DispatchQueue(label: "image.processing", qos: .userInitiated)
    
    init() {
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            context = CIContext(mtlDevice: metalDevice)
        } else {
            context = CIContext()
        }
    }
    
    func applyFilters(to image: UIImage, 
                     brightness: Double = 0.0,
                     contrast: Double = 1.0,
                     saturation: Double = 1.0,
                     warmth: Double = 0.0,
                     shadows: Double = 0.0,
                     completion: @escaping (UIImage) -> Void) {
        
        processingQueue.async { [weak self] in
            guard let self = self else {
                DispatchQueue.main.async { completion(image) }
                return
            }
            
            let processedImage = self.processImageSync(image, 
                                                     brightness: brightness,
                                                     contrast: contrast,
                                                     saturation: saturation,
                                                     warmth: warmth,
                                                     shadows: shadows)
            
            DispatchQueue.main.async {
                completion(processedImage)
            }
        }
    }
    
    // Synchronous version for immediate processing
    func applyFilters(to image: UIImage, 
                     brightness: Double = 0.0,
                     contrast: Double = 1.0,
                     saturation: Double = 1.0,
                     warmth: Double = 0.0,
                     shadows: Double = 0.0) -> UIImage {
        
        return processImageSync(image, brightness: brightness, contrast: contrast, 
                               saturation: saturation, warmth: warmth, shadows: shadows)
    }
    
    private func processImageSync(_ image: UIImage,
                                brightness: Double,
                                contrast: Double,
                                saturation: Double,
                                warmth: Double,
                                shadows: Double) -> UIImage {
        
        guard let ciImage = CIImage(image: image) else { return image }
        var outputImage = ciImage
        
        // Apply basic color controls
        if brightness != 0.0 || contrast != 1.0 || saturation != 1.0 {
            let colorFilter = CIFilter.colorControls()
            colorFilter.inputImage = outputImage
            colorFilter.brightness = Float(brightness)
            colorFilter.contrast = Float(contrast)
            colorFilter.saturation = Float(saturation)
            outputImage = colorFilter.outputImage ?? outputImage
        }
        
        // Apply temperature adjustment
        if warmth != 0.0 {
            let temperatureFilter = CIFilter.temperatureAndTint()
            temperatureFilter.inputImage = outputImage
            temperatureFilter.neutral = CIVector(x: 6500 + CGFloat(warmth * 1000), y: 0)
            outputImage = temperatureFilter.outputImage ?? outputImage
        }
        
        // Apply shadow adjustment
        if shadows != 0.0 {
            let shadowFilter = CIFilter.highlightShadowAdjust()
            shadowFilter.inputImage = outputImage
            shadowFilter.shadowAmount = Float(shadows)
            outputImage = shadowFilter.outputImage ?? outputImage
        }
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return image
        }
        
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }
    
    func resizeImage(_ image: UIImage, to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
