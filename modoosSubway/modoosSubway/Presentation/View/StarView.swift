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
					CardView(cards: $cards, viewType: .Star)
						.onAppear {
							cards = starItems.map { $0.subwayCard }
                            print("전체 저장된 아이템:")
                            starItems.enumerated().forEach { index, star in
                                   print("""
                                       
                                       카드 \(index + 1)
                                       ID: \(star.subwayCard.id)
                                       역명: \(star.subwayCard.stationName)
                                       호선: \(star.subwayCard.lineNumber)
                                       방향: \(star.subwayCard.upDownLine)
                                       도착 메시지: \(star.subwayCard.arrivalMessage)
                                       급행여부: \(star.subwayCard.isExpress)
                                       즐겨찾기: \(star.subwayCard.isStar)
                                       폴더여부: \(star.subwayCard.isFolder)
                                       하하: \(star.subwayCard)
                                       --------------------------------
                                       """)
                               }

                            print("현재 표시되는 카드 수: \(cards.count)")
						}
				}
			})
		}
		.onAppear {
			DataManager.shared.setModelContext(modelContext)
            print("StarView appeared - 저장된 아이템 수: \(starItems.count)")
		}
		.padding(.top, 22)
		.padding(.horizontal, 1)
	}
}

#Preview {
	StarView()
		.modelContainer(for: Star.self, inMemory: true)
}
