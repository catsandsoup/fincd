//
//  Item.swift
//  finc'd
//
//  Created by Monty Giovenco on 18/4/2026.
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
