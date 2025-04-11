//
//  Item.swift
//  Tuner
//
//  Created by Ashish on 04/03/25.
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
