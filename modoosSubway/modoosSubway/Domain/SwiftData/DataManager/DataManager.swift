//
//  DataManager.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/07/21.
//

import SwiftData
import SwiftUI

class DataManager {
	static let shared = DataManager()
	private var modelContext: ModelContext?
	
	func setModelContext(_ context: ModelContext) {
		self.modelContext = context
	}
	
	// MARK: - 즐겨찾기 추가
	func addStar(item: Star) {
		modelContext?.insert(item)
		print("add star complete \(item)")
	}
	
	// MARK: - 즐겨찾기 제거
	func deleteStar(item: Star) {
		modelContext?.delete(item)
		print("delete star complete \(item)")
	}
}
