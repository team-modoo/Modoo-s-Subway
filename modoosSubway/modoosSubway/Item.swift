//
//  Item.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/07/20.
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
