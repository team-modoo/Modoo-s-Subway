//
//  StarView.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/07/21.
//

import SwiftUI
import SwiftData

struct StarView: View {
	
	@Environment(\.modelContext) private var modelContext
	@Query private var starItems: [Star]
	@State private var cards: [CardViewEntity] = []
	
	var body: some View {
		VStack {
			GeometryReader(content: { geometry in
				if starItems.isEmpty {
					VStack {
						Image(.starCircle)
						Text("자주 타는 지하철 노선을 추가해주세요")
							.font(.pretendard(size: 16, family: .regular))
							.foregroundStyle(Color("5C5C5C"))
							.padding(.top, 8)
					}
					.frame(width: geometry.size.width, height: 196)
					.background(
						RoundedRectangle(cornerRadius: 10)
							.stroke(.EDEDED)
					)
				} else {
					CardView(cards: $cards)
						.onAppear {
							cards = starItems.map { $0.subwayCard }
						}
				}
			})
		}
		.onAppear {
			DataManager.shared.setModelContext(modelContext)
		}
		.padding(.top, 22)
		.padding(.horizontal, 1)
	}
}

#Preview {
	StarView()
		.modelContainer(for: Star.self, inMemory: true)
}
