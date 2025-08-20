//
//  DetailsController 2.swift
//  vividify 3.0
//
//  Created by Collins Roy on 20/08/25.
//


// DetailsController.swift
import Foundation
import SwiftUI
import Combine

class DetailsController: ObservableObject {
    @Published var brightness: Double = 0 {
        didSet { scheduleFilterUpdate() }
    }
    @Published var contrast: Double = 1 {
        didSet { scheduleFilterUpdate() }
    }
    @Published var saturation: Double = 1 {
        didSet { scheduleFilterUpdate() }
    }
    @Published var warmth: Double = 0 {
        didSet { scheduleFilterUpdate() }
    }
    @Published var shadows: Double = 0 {
        didSet { scheduleFilterUpdate() }
    }
    
    @Published var filteredImage: UIImage?
    @Published var selectedPreset: FilterPreset?
    @Published var isProcessing = false
    
    private var originalImage: UIImage?
    private var updateTimer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    func setOriginalImage(_ image: UIImage) {
        originalImage = image
        filteredImage = image
    }
    
    private func scheduleFilterUpdate() {
        updateTimer?.invalidate()
        isProcessing = true
        
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { [weak self] _ in
            self?.updateFilteredImage()
        }
    }
    
    private func updateFilteredImage() {
        guard let original = originalImage else { return }
        
        ImageProcessor.shared.applyFilters(
            to: original,
            brightness: brightness,
            contrast: contrast,
            saturation: saturation,
            warmth: warmth,
            shadows: shadows
        ) { [weak self] processedImage in
            self?.filteredImage = processedImage
            self?.isProcessing = false
        }
    }
    
    func applyPreset(_ preset: FilterPreset) {
        selectedPreset = preset
        brightness = preset.brightness
        contrast = preset.contrast
        saturation = preset.saturation
        warmth = preset.warmth
        shadows = preset.shadows
    }
    
    func resetToDefaults() {
        brightness = 0
        contrast = 1
        saturation = 1
        warmth = 0
        shadows = 0
        selectedPreset = nil
    }
    
    func applyFilters(to image: UIImage?) -> UIImage? {
        guard let image = image else { return nil }
        return ImageProcessor.shared.applyFilters(
            to: image,
            brightness: brightness,
            contrast: contrast,
            saturation: saturation,
            warmth: warmth,
            shadows: shadows
        )
    }
}