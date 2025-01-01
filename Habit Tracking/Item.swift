//
//  Item.swift
//  Habit Tracking
//
//  Created by Felipe Morais on 01/01/25.
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
