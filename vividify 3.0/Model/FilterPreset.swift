//
//  FilterPreset.swift
//  vividify 3.0
//
//  Created by Collins Roy on 20/08/25.
//


import UIKit

struct FilterPreset {
    let name: String
    let brightness: Double
    let contrast: Double
    let saturation: Double
    let warmth: Double
    let shadows: Double
    
    static let presets: [FilterPreset] = [
        FilterPreset(name: "Original", brightness: 0, contrast: 1, saturation: 1, warmth: 0, shadows: 0),
        FilterPreset(name: "Vivid", brightness: 0.1, contrast: 1.2, saturation: 1.3, warmth: 0.1, shadows: 0.1),
        FilterPreset(name: "Dramatic", brightness: -0.1, contrast: 1.4, saturation: 0.8, warmth: -0.1, shadows: 0.3),
        FilterPreset(name: "Warm", brightness: 0.05, contrast: 1.1, saturation: 1.1, warmth: 0.3, shadows: 0.05),
        FilterPreset(name: "Cool", brightness: 0, contrast: 1.05, saturation: 1.05, warmth: -0.2, shadows: 0),
        FilterPreset(name: "Vintage", brightness: 0.1, contrast: 0.9, saturation: 0.8, warmth: 0.2, shadows: 0.2)
    ]
}
