//
//  CardListView.swift
//  modoosSubway
//
//  Created by 김지현 on 12/16/24.
//

import SwiftUI
import SwiftData

struct CardListView: View {
	
	@Binding var cards: [CardViewEntity]
	@State private var showModal: Bool = false
	@State private var showAlert: Bool = false
	@State private var alertMessage: String = ""
	@State private var selectedCard: CardViewEntity?
	@State private var countdowns: [UUID: Int] = [:]
	@State private var lastBarvlDts: [UUID: String] = [:]
	var onStarSaved: ((Bool) -> Void)? = nil
	private var viewType: ViewType?
	let folder: Folder?
	var isEditingMode: Bool
	var onOrderChanged: (([CardViewEntity]) -> Void)?
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	
	init(cards: Binding<[CardViewEntity]>,
		 viewType: ViewType? = nil,
		 isEditingMode: Bool = false,
		 folder: Folder? = nil,
		 onOrderChanged: (([CardViewEntity]) -> Void)? = nil,
		 onStarSaved: ((Bool) -> Void)? = nil
	) {
		_cards = cards
		self.viewType = viewType
		self.isEditingMode = isEditingMode
		self.folder = folder
		self.onOrderChanged = onOrderChanged
		self.onStarSaved = onStarSaved
	}
	
	var body: some View {
		List {
			ForEach(cards) { card in
				CardView(cards: $cards,
						 card: card,
						 viewType: viewType,
						 selectedCard: $selectedCard,
						 alertMessage: $alertMessage,
						 showAlert: $showAlert,
						 folder: folder,
						 onStarSaved: onStarSaved)
				.buttonStyle(PlainButtonStyle())
				.listRowSeparator(.hidden)
			}
			.onMove(perform: isEditingMode ? moveCards : nil)
		}
		.listStyle(.plain)
		.scrollIndicators(.hidden)
		.environment(\.editMode, .constant(isEditingMode ? .active : .inactive))
		.onAppear {
			for card in cards {
				initializeCountdowns(for: card)
			}
		}
		.onChange(of: cards) { _, newCards in
			for card in newCards {
				updateCountdownsIfNeeded(card: card, arrivals: card.arrivals)
			}
		}
		.onReceive(timer) { _ in
			for card in cards {
				for arrival in card.arrivals {
					if let currentCount = countdowns[arrival.id], currentCount > 0 {
						countdowns[arrival.id] = currentCount - 1
					}
				}
			}
		}
		.sheet(item: $selectedCard) { card in
			getMoreMenu(for: card)
		}
		.alert("알림", isPresented: $showAlert) {
			Button("확인", role: .cancel) {}
		} message: {
			Text(alertMessage)
		}
	}
	
	// Add this method to the struct
	private func moveCards(from offsets: IndexSet, to destination: Int) {
		cards.move(fromOffsets: offsets, toOffset: destination)
		onOrderChanged?(cards)
	}
	
	private func getMoreMenu(for card: CardViewEntity) -> some View {
		if let folder = folder {
			return AnyView(
				MoreMenuListView(card: card, folder: folder)
					.presentationDetents([.fraction(0.3)])
					.presentationDragIndicator(.visible)
					.presentationCornerRadius(26)
			)
		} else {
			return AnyView(
				AddFolderView(card: card)
					.presentationDetents([.fraction(0.3)])
					.presentationDragIndicator(.visible)
					.presentationCornerRadius(26)
			)
		}
	}
	
	private func getFormattedTime(for arrival: Arrival) -> (Int, Int) {
		let totalSeconds = countdowns[arrival.id] ?? Int(arrival.barvlDt) ?? 0
		let minutes = totalSeconds / 60
		let seconds = totalSeconds % 60
		return (minutes, seconds)
	}
	
	private func initializeCountdowns(for card: CardViewEntity) {
		// 최초 진입시에만 초기화
		for arrival in card.arrivals {
			if countdowns[arrival.id] == nil {
				countdowns[arrival.id] = Int(arrival.barvlDt) ?? 0
				lastBarvlDts[arrival.id] = arrival.barvlDt
			}
		}
	}
	
	private func updateCountdownsIfNeeded(card: CardViewEntity, arrivals: [Arrival]) {
		for arrival in arrivals {
			// 이전 barvlDt와 현재 값이 다르면 (API에서 새로운 값을 받았으면) 카운트다운 업데이트
			if lastBarvlDts[arrival.id] != arrival.barvlDt {
				countdowns[arrival.id] = Int(arrival.barvlDt) ?? 0
				lastBarvlDts[arrival.id] = arrival.barvlDt
			}
		}
	}
}
