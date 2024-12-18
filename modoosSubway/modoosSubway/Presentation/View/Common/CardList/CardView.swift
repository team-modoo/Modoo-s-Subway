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
	@Binding private var selectedCard: CardViewEntity?
	@Binding private var alertMessage: String
	@Binding private var showAlert: Bool
	var onStarSaved: ((Bool) -> Void)? = nil
	var card: CardViewEntity
	let folder: Folder?
	private var viewType: ViewType?
	
	init(cards: Binding<[CardViewEntity]>, 
		 card: CardViewEntity,
		 viewType: ViewType?,
		 selectedCard: Binding<CardViewEntity?>,
		 alertMessage: Binding<String>,
		 showAlert: Binding<Bool>,
		 folder: Folder? = nil,
		 onStarSaved: ((Bool) -> Void)? = nil) {
		self._cards = cards
		self.card = card
		self.viewType = viewType
		self._selectedCard = selectedCard
		self._alertMessage = alertMessage
		self._showAlert = showAlert
		self.folder = folder
		self.onStarSaved = onStarSaved
	}
	
	var body: some View {
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
					card.isStar ? Image(.iconStarYellow) : Image(.iconStar)
				})
				.buttonStyle(BorderlessButtonStyle())
				
				if let _ = viewType {
					// MARK: - 더보기 버튼
					Button(action: {
						selectedCard = card
					}, label: {
						Image(.iconMoreGray)
					})
				}
			}
			.padding(.top, 20)
			
			HStack(alignment: .center) {
				if let firstArrival = card.arrivals.first {
					Text(Util.formatArrivalMessage(firstArrival.message2))
						.font(.pretendard(size: 28, family: .semiBold))
					
					Rectangle()
						.frame(width: 1, height: 12)
						.foregroundStyle(.EDEDED)
					
					if let secondArrival = card.arrivals.dropFirst().first {
						Text("다음열차 \(Util.formatArrivalMessage(secondArrival.message2))")
							.font(.pretendard(size: 14, family: .regular))
					}
				}
			}
			.frame(width: 300, alignment: .leading)
			.offset(x: -8)
			
			ZStack {
				HStack(alignment: .top, spacing: 0) {
					getStationNamesView(card)
				}
				.offset(y: 28)
				
				HStack {
					getArrivalsView(card)
				}
				.offset(y: -7.1)
			}
			.offset(y: 12)
			
			Spacer()
			
			if let firstArrival = card.arrivals.first {
				let direction = Util.getTrainDirection(firstArrival.trainLineName)
				Text("이 전철은 \(direction) 전철입니다.")
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
			} else {
				Text("이 전철은 \(card.upDownLine) 열차입니다.")
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
		}
		.padding(.horizontal,20)
		.frame(width: 350, height: 223)
		.background(
			RoundedRectangle(cornerRadius: 10)
				.stroke(.EDEDED)
		)
	}
	
	// MARK: - 지하철 5개의 정거장 라인 뷰
	private func getStationNamesView(_ card: CardViewEntity) -> some View {
		ForEach(card.stationNames, id: \.self) { el in
			VStack {
				if el != card.stationNames.last {
					Circle()
						.frame(width: 8, height: 8)
						.foregroundColor(Util.getLineColor(card.lineNumber))
						.opacity(0.7)
				} else {
					Circle()
						.frame(width: 8, height: 8)
						.foregroundColor(.white)
						.overlay(
							Circle()
								.stroke(Util.getLineColor(card.lineNumber), lineWidth: 1)
						)
				}
				
				Text(el)
					.font(.pretendard(size: 12, family: .regular))
					.frame(width: CGFloat(el.count * 12))
			}
			.frame(width: 20)
			
			if el != card.stationNames.last {
				Rectangle()
					.frame(width: 80, height: 8)
					.padding(.horizontal, -12)
					.padding(.top, 0)
					.foregroundStyle(
						Util.getLineColor(card.lineNumber)
					)
					.opacity(0.3)
			}
		}
	}
	
	// MARK: - 열차 뷰
	private func getArrivalsView(_ card: CardViewEntity) -> some View {
		ForEach(card.arrivals) { el in
			VStack(spacing: -14) {
				Text(Util.formatTrainLineName(el.trainLineName))
					.font(.pretendard(size: 12, family: .medium))
					.padding(.horizontal, 8)
					.padding(.vertical, 5)
					.foregroundColor(._333333)
					.background(
						RoundedRectangle(cornerRadius: 6)
							.fill(Util.getLineColor(card.lineNumber))
							.opacity(0.1)
					)
					.offset(y: -2)
				
				ZStack(alignment: .center) {
					Circle()
						.frame(width: 16, height: 16)
						.foregroundColor(Util.getLineColor(card.lineNumber))
						.opacity(0.7)
						.offset(y: 20)
					
					Circle()
						.frame(width: 8, height: 8)
						.foregroundColor(.white)
						.offset(y: 20)
				}
			}
		}
	}
	
	private func isDuplicateStar(_ item: CardViewEntity) -> Bool {
		let descriptor = FetchDescriptor<Star>()
		guard let stars = try? modelContext.fetch(descriptor) else { return false }
		
		return stars.contains { star in
			let card = star.subwayCard
			return card.stationNames == item.stationNames &&
			card.lineNumber == item.lineNumber &&
			card.upDownLine == item.upDownLine &&
			card.isExpress == item.isExpress
		}
	}
	
	func toggleStar(for item: CardViewEntity) {
		if let index = cards.firstIndex(where: { $0 == item }) {
			if !cards[index].isStar {
				if isDuplicateStar(item) {
					alertMessage = "\(item.stationName) \(item.upDownLine)은(는)\n이미 즐겨찾기에 저장되어 있습니다"
					showAlert = true
					return
				}
				
				let star = Star(subwayCard: cards[index])
				DataManager.shared.addStar(item: star)
				
				cards[index].isStar = true
				onStarSaved?(true)
			} else {
				let descriptor = FetchDescriptor<Star>()
				if let stars = try? modelContext.fetch(descriptor),
				   let starToDelete = stars.first(where: { $0.subwayCard == item }) {
					if let folder = folder {
						DataManager.shared.deleteStar(item: starToDelete)
						DataManager.shared.updateFolderLineNumbers(folder, context: modelContext)
					} else {
						// 폴더가 없는 경우(StarView 등)는 기존처럼 처리
						DataManager.shared.deleteStar(item: starToDelete)
					}
				}
				
				// Directly mutate the binding
				cards[index].isStar = false
				onStarSaved?(false)
			}
		}
	}
}
