//
//  ToolsController.swift
//  vividify 3.0
//
//  Created by Collins Roy on 20/08/25.
//


// Enhanced ToolsController.swift
import Foundation
import SwiftUI

class ToolsController: ObservableObject {
    @Published var selectedTool: ToolOption?
    @Published var isToolActive = false
    
    enum ToolOption: CaseIterable {
        case crop, details, tune, draw
        
        var title: String {
            switch self {
            case .crop: return "Crop"
            case .details: return "Details"
            case .tune: return "Tune"
            case .draw: return "Draw"
            }
        }
        
        var systemImage: String {
            switch self {
            case .crop: return "crop"
            case .details: return "slider.horizontal.3"
            case .tune: return "slider.horizontal.below.square.filled.and.square"
            case .draw: return "pencil.tip.crop.circle"
            }
        }
    }
    
    func selectTool(_ tool: ToolOption) {
        selectedTool = tool
        isToolActive = true
    }
    
    func clearSelection() {
        selectedTool = nil
        isToolActive = false
    }
}