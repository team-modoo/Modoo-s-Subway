//
//  Item.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/07/20.
//

import SwiftUI
import SwiftData

@Model
final class Folder {
    let id: UUID
    var title: String
    var content: String?
    var timestamp: Date
    var backgroundImage: String?
    var lineNumber: [String]

    var cardIDs: [UUID] = []
    
    init(timestamp: Date,lineNumber: [String],title: String, content: String?) {
        self.id = UUID()
        self.timestamp = timestamp
        self.lineNumber = lineNumber
        self.title = title
        self.content = content
    }
}

@Model
final class Star {
	var subwayCard: CardViewEntity
	
	init(subwayCard: CardViewEntity) {
		self.subwayCard = subwayCard
	}
}
