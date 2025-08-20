//
//  TuneImageModel.swift
//  vividify 3.0
//
//  Created by Collins Roy on 20/08/25.
//



// Enhanced TuneImageModel.swift
import UIKit

struct TuneImageModel {
    var originalImage: UIImage
    var adjustedImage: UIImage?
    
    // Fine-tuning parameters
    var smoothness: Double = 0.0
    var sharpness: Double = 0.0
    var clarity: Double = 0.0
    var structure: Double = 0.0
    var vignette: Double = 0.0
    var noiseReduction: Double = 0.0
    
    mutating func resetToDefaults() {
        smoothness = 0.0
        sharpness = 0.0
        clarity = 0.0
        structure = 0.0
        vignette = 0.0
        noiseReduction = 0.0
        adjustedImage = originalImage
    }
    
    mutating func updateAdjustedImage(_ image: UIImage) {
        adjustedImage = image
    }
}

