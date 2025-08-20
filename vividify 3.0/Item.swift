//
//  Item.swift
//  vividify 3.0
//
//  Created by Collins Roy on 20/08/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
