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
    let id: UUID
    var timestamp: Date
    
    @Relationship(inverse:\Folder.items)
    var folders: [Folder] = []
    
    init(timestamp: Date) {
        self.id = UUID()
        self.timestamp = timestamp
    }
}

@Model
final class Folder {
    let id: UUID
    var content: String
    var timestamp: Date
    var backgroundImage: String?
    var lineNumber: [String]
    
    @Relationship(deleteRule: .nullify)
    var items: [Item] = []
    
    init(timestamp: Date,lineNumber: [String],content: String) {
        self.id = UUID()
        self.timestamp = timestamp
        self.lineNumber = lineNumber
        self.content = content
    }
}
