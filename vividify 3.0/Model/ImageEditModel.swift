//
//  ImageEditModel.swift
//  vividify 3.0
//
//  Created by Collins Roy on 20/08/25.
//


import Foundation
import SwiftUI
import UIKit

class ImageEditModel: ObservableObject {
    @Published var selectedImage: UIImage? = nil
    @Published var processedImage: UIImage? = nil
    @Published var isGalleryPickerPresented = false
    @Published var isCameraPickerPresented = false
    @Published var isProcessing = false
    @Published var editHistory: [UIImage] = []
    @Published var currentHistoryIndex: Int = -1
    @Published var showingSaveAlert = false
    @Published var saveSuccess = false
    
    var isImageSelected: Bool {
        return selectedImage != nil
    }
    
    var canUndo: Bool {
        return currentHistoryIndex > 0
    }
    
    var canRedo: Bool {
        return currentHistoryIndex < editHistory.count - 1
    }
    
    func setSelectedImage(_ image: UIImage) {
        selectedImage = image
        processedImage = image
        editHistory = [image]
        currentHistoryIndex = 0
    }
    
    func addToHistory(_ image: UIImage) {
        if currentHistoryIndex < editHistory.count - 1 {
            editHistory.removeSubrange((currentHistoryIndex + 1)...)
        }
        
        editHistory.append(image)
        currentHistoryIndex = editHistory.count - 1
        
        // Limit history to prevent memory issues
        if editHistory.count > 15 {
            editHistory.removeFirst()
            currentHistoryIndex -= 1
        }
    }
    
    func undo() {
        guard canUndo else { return }
        currentHistoryIndex -= 1
        processedImage = editHistory[currentHistoryIndex]
        selectedImage = editHistory[currentHistoryIndex]
    }
    
    func redo() {
        guard canRedo else { return }
        currentHistoryIndex += 1
        processedImage = editHistory[currentHistoryIndex]
        selectedImage = editHistory[currentHistoryIndex]
    }
    
    func clearImage() {
        selectedImage = nil
        processedImage = nil
        editHistory.removeAll()
        currentHistoryIndex = -1
    }
}
