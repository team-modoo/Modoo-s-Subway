//
//  StarViewModel.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/08/03.
//

import SwiftUI
import Combine

class StarViewModel: ObservableObject {
	
	@Published var errorMessage: String?
	@Published var isError: Bool = false
	@Environment(\.modelContext) private var modelContext
	@Published private var cards: [CardViewEntity] = []
	
	init() {}
	
	
}
