//
//  TuneImageController.swift
//  vividify 3.0
//
//  Created by Collins Roy on 20/08/25.
//

import Foundation
import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import Combine

class TuneImageController: ObservableObject {
    @Published var model: TuneImageModel
    @Published var isProcessing = false
    
    private let context: CIContext
    private var updateTimer: Timer?
    private var cancellables = Set<AnyCancellable>()

    init(image: UIImage) {
        self.model = TuneImageModel(originalImage: image)
        
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            context = CIContext(mtlDevice: metalDevice)
        } else {
            context = CIContext()
        }
        
        applyFilters()
        setupBindings()
    }
    
    private func setupBindings() {
        $model
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.applyFilters()
            }
            .store(in: &cancellables)
    }

    func applyFilters() {
        updateTimer?.invalidate()
        isProcessing = true
        
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false) { [weak self] _ in
            self?.processFilters()
        }
    }
    
    private func processFilters() {
        guard let ciImage = CIImage(image: model.originalImage) else { 
            isProcessing = false
            return 
        }
        
        var outputImage = ciImage
        
        if model.smoothness > 0 {
            let smoothnessFilter = CIFilter.gaussianBlur()
            smoothnessFilter.inputImage = outputImage
            smoothnessFilter.radius = Float(model.smoothness * 8)
            outputImage = smoothnessFilter.outputImage ?? outputImage
        }
        
        if model.sharpness > 0 {
            let sharpnessFilter = CIFilter.unsharpMask()
            sharpnessFilter.inputImage = outputImage
            sharpnessFilter.radius = Float(model.sharpness * 2.5)
            sharpnessFilter.intensity = Float(model.sharpness * 0.8)
            outputImage = sharpnessFilter.outputImage ?? outputImage
        }
        
        if model.clarity != 0 {
            let clarityFilter = CIFilter.unsharpMask()
            clarityFilter.inputImage = outputImage
            clarityFilter.radius = Float(abs(model.clarity) * 20)
            clarityFilter.intensity = Float(model.clarity * 0.5)
            outputImage = clarityFilter.outputImage ?? outputImage
        }
        
        if model.vignette != 0 {
            let vignetteFilter = CIFilter.vignette()
            vignetteFilter.inputImage = outputImage
            vignetteFilter.intensity = Float(model.vignette)
            vignetteFilter.radius = Float(1.0)
            outputImage = vignetteFilter.outputImage ?? outputImage
        }
        
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.model.adjustedImage = UIImage(
                    cgImage: cgImage,
                    scale: self.model.originalImage.scale,
                    orientation: self.model.originalImage.imageOrientation
                )
                self.isProcessing = false
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.isProcessing = false
            }
        }
    }
    
    func resetToDefaults() {
        model.resetToDefaults()
        applyFilters()
    }
}
