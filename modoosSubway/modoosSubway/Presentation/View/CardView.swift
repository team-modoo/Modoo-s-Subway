//
//  CardView.swift
//  modoosSubway
//
//  Created by 김지현 on 11/17/24.
//

import SwiftUI
import SwiftData

struct CardView: View {

	@Environment(\.modelContext) private var modelContext
	@Binding var cards: [CardViewEntity]
	@State private var showModal = false
	private var viewType: ViewType?
	
	init(cards: Binding<[CardViewEntity]>, viewType: ViewType? = nil) {
		_cards = cards
		self.viewType = viewType
	}
	
	var body: some View {
		List(cards) { card in
			VStack {
				HStack {
					Text(card.lineName)
						.font(.pretendard(size: 12, family: .regular))
						.foregroundStyle(.white)
						.padding(.horizontal, 8)
						.padding(.vertical, 5)
						.background(Util.getLineColor(card.lineNumber))
						.cornerRadius(14)
					
					Text(card.stationName)
						.font(.pretendard(size: 16, family: .medium))
					
					Spacer()
					
					// MARK: - 즐겨찾기 버튼
					Button(action: {
						toggleStar(for: card)
					}, label: {
						card.isStar ?  Image(.iconStarYellowBig) : Image(.iconStar)
					})
					.buttonStyle(BorderlessButtonStyle())
					
					if let _ = viewType {
						// MARK: - 더보기 버튼
						Button(action: {
							showModal.toggle()
						}, label: {
							Image(.iconMore)
						})
					}
				}
				.padding(.top, 24)
				
				HStack(alignment: .firstTextBaseline) {
					Text(Util.formatArrivalMessage(card.arrivalMessage))
						.font(.pretendard(size: 28, family: .semiBold))
					
					if Util.isArrivalTimeFormat(card.arrivalMessage) {
						Text("후 도착 예정")
							.font(.pretendard(size: 16, family: .regular))
					}
				}
				.frame(width: 300, alignment: .leading)
				.offset(x: -8)
				
				HStack {
					ForEach(card.arrivals, id: \.self) { el in
                        
                        VStack(spacing: -4) {
                            Text(Util.formatTrainLineName(el.trainLineName))
                                .font(.pretendard(size: 12, family: .medium))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 5)
                                .foregroundColor(._333333)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.F_4_F_6_EB)
                                )
                            
                            Image(.group4)
                                .frame(width: 8,height: 8)
                                .foregroundStyle(Util.getLineColor(card.lineNumber))
                                .offset(y:19)
                        }
                        
					
					}
				}
				
				HStack(alignment: .top, spacing: 0) {
					getStationNamesView(card)
				}
				.padding(.top, 4)
				
				Spacer()
				
				Text("이 전철은 \(card.upDownLine) 방향 전철입니다.")
					.font(.pretendard(size: 12, family: .bold))
					.frame(width: 350, height: 24, alignment: .center)
					.foregroundStyle(.white)
					.background(
						Util.getLineColor(card.lineNumber)
							.clipShape(
								.rect(
									topLeadingRadius: 0,
									bottomLeadingRadius: 10,
									bottomTrailingRadius: 10,
									topTrailingRadius: 0
								)
							)
					)
			}
			.buttonStyle(PlainButtonStyle())
			.listRowSeparator(.hidden)
			.padding(.horizontal, 20)
			.frame(width: 350, height: 213)
			.background(
				RoundedRectangle(cornerRadius: 10)
					.stroke(.EDEDED)
			)
		}
		.listStyle(.plain)
		.scrollIndicators(.hidden)
		.sheet(isPresented: $showModal) {
            MoreMenuListView()
				.presentationDetents([.fraction(1/4)])
				.presentationDragIndicator(.visible)
				.presentationCornerRadius(26)
		}
	}
	
	// MARK: - 지하철 5개의 정거장 라인 뷰
	private func getStationNamesView(_ card: CardViewEntity) -> some View {
		ForEach(card.stationNames, id: \.self) { el in
			VStack {
				Circle()
					.frame(width: 8, height: 8)
					.foregroundColor(Util.getLineColor(card.lineNumber))
				Text(el)
					.font(.pretendard(size: 12, family: .regular))
					.frame(width: CGFloat(el.count * 12))
			}
			.frame(width: 20)
			
			if el != card.stationNames.last {
				Rectangle()
					.frame(width: 80, height: 2)
					.padding(.horizontal, -12)
					.padding(.top, 2)
					.foregroundStyle(
						Util.getLineColor(card.lineNumber)
					)
					.opacity(0.3)
			}
		}
	}
	
	// MARK: - 즐겨찾기 토글
	func toggleStar(for item: CardViewEntity) {
		if let index = cards.firstIndex(where: { $0 == item }) {
			cards[index].isStar.toggle()
			
			if cards[index].isStar {
				let star = Star(subwayCard: cards[index])
				DataManager.shared.addStar(item: star)
			} else {
				// 삭제할 Star 찾기
				let descriptor = FetchDescriptor<Star>()
				if let stars = try? modelContext.fetch(descriptor),
				   let starToDelete = stars.first(where: { $0.subwayCard == item }) {
					DataManager.shared.deleteStar(item: starToDelete)
				}
			}
		}
	}
}
