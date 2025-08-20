//
//  DrawingModel.swift
//  vividify 3.0
//
//  Created by Collins Roy on 20/08/25.
//


// DrawingModel.swift
import UIKit
import PencilKit

struct DrawingModel {
    var image: UIImage?
    var drawing: PKDrawing = PKDrawing()
    var canvasSize: CGSize = .zero
    
    mutating func updateDrawing(_ newDrawing: PKDrawing) {
        drawing = newDrawing
    }
    
    mutating func setImage(_ image: UIImage) {
        self.image = image
        self.canvasSize = image.size
    }
    
    mutating func clearDrawing() {
        drawing = PKDrawing()
    }
    
    func combinedImage(size: CGSize? = nil) -> UIImage? {
        guard let image = image else { return nil }
        
        let targetSize = size ?? canvasSize
        guard targetSize.width > 0 && targetSize.height > 0 else { return nil }
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
            let drawingImage = drawing.image(from: CGRect(origin: .zero, size: targetSize), scale: UIScreen.main.scale)
            drawingImage.draw(in: CGRect(origin: .zero, size: targetSize), blendMode: .normal, alpha: 1.0)
        }
    }
}
