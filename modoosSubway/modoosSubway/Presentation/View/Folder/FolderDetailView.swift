//
//  FolderDetailView.swift
//  modoosSubway
//
//  Created by 김지현 on 12/16/24.
//

import SwiftUI
import SwiftData
import Combine

// MARK: - 리팩토링 필요
struct FolderDetailView: View {
	
	@Environment(\.modelContext) private var modelContext
	private let subwayUseCase: SubwayUseCaseProtocol = SubwayUseCase(repository: SubwayRepository())
	@Query private var starItems: [Star]
	@State private var cards: [CardViewEntity] = []
	@State private var isLoading = true
	@Environment(\.dismiss) var dismiss
	@State private var showAlert = false
	@State var viewType2: FolderType = .Card
	@State var sortedType: StarSortedType = .all
	@State private var expressActiveState = false
	@State private var filteredCards: [CardViewEntity] = []
	let folder: Folder
	let isEditingMode: Bool
	private var cancellables =  Set<AnyCancellable>()
	
	init(folder:Folder, isEditingMode:Bool = false) {
		self.folder = folder
		self.isEditingMode = isEditingMode
	}
	
	var body: some View {
		ZStack(alignment: .bottomTrailing) {
			VStack {
				GeometryReader(content: { geometry in
					HStack {
						Button(action: {
							dismiss()
						}) {
							Image(.back)
							Text(folder.title)
								.padding(.leading, -10)
								.font(.pretendard(size: 18, family: .semiBold))
								.tint(._333333)
						}
						
						Spacer()
						
						if isEditingMode {
							Button("완료") {
								dismiss()
							}
							.font(.pretendard(size: 16, family: .medium))
							.foregroundColor(.blue)
						}
					}
					.background(Color.white)
					
					if cards.isEmpty {
						VStack {
							Spacer()
								.frame(height: 54)
							
							VStack {
								Image(.starCircle)
								Text("이 폴더에 추가된 카드가 없습니다")
									.font(.pretendard(size: 16, family: .regular))
									.foregroundStyle(Color("5C5C5C"))
									.padding(.top, 8)
							}
							.frame(width: geometry.size.width, height: 196)
							.background(
								RoundedRectangle(cornerRadius: 10)
									.stroke(.EDEDED)
							)
						}
					} else {
						VStack {
//							HStack {
//								StarHeaderView(viewType: $viewType2,
//											   sortedType: $sortedType,
//											   expressActiveState: $expressActiveState)
//							}
							
							CardListView(cards: $cards, viewType: .Folder, isEditingMode: isEditingMode, folder: folder) { updatedCards in
								// 순서가 변경될 때마다 호출됨
//								let newOrder = updatedCards.map { $0.id }
//								DataManager.shared.updateFolderCardOrder(folder, newOrder: newOrder, context: modelContext)
							}
							.onChange(of: sortedType) { _, newValue in
								updateFilteredCards()
							}
							.onChange(of: cards) { _, _ in
								updateFilteredCards()
							}
							.onChange(of: expressActiveState) { _, _ in
								updateFilteredCards()
							}
						}
						.padding(.top, 30)
					}
				})
			}
			.navigationBarHidden(true)
			.onAppear {
				loadCards()
			}
			.padding(.top, 30)
			.padding(.horizontal, 20)
			
			if !cards.isEmpty && !isLoading {
				VStack(spacing: 16) {
					Button(action: {
						showAlert = true
					}) {
						Image(.btnAlarm)
							.foregroundColor(.blue)
							.background(Circle().fill(Color.white))
					}
					
					Button(action: {
//						refreshCards()
					}) {
						Image(.btnRefresh)
							.foregroundColor(.blue)
							.background(Circle().fill(Color.white))
						
					}
				}
				.padding(.bottom, 30)
				.padding(.trailing, 20)
			}
		}
		.alert("", isPresented: $showAlert) {
			Button("확인", role: .cancel) {}
		} message: {
			Text("준비중인 기능입니다.")
		}
	}
	
	private func loadCards() {
		isLoading = true
		// 폴더에 저장된 UUID에 해당하는 카드만 필터링
		// 1. 먼저 해당 폴더의 카드들을 필터링
		let filteredCards = starItems
			.map { $0.subwayCard }
			.filter { folder.cardIDs.contains($0.id) }
		
			// 2. folder.cardIDs의 순서대로 정렬
		cards = folder.cardIDs.compactMap { cardID in
			filteredCards.first { $0.id == cardID }
		}
		isLoading = false
	}
	
	private func updateFilteredCards() {
		let allCards = cards.sorted { $0.stationName < $1.stationName }
		var filtered: [CardViewEntity]
		
		switch sortedType {
		case .all:
			filtered = allCards
		case .upLine:
			filtered = allCards.filter { $0.upDownLine == "상행선" }
		case .downLine:
			filtered = allCards.filter { $0.upDownLine == "하행선" }
		}
		
		if expressActiveState {
			filtered = filtered.filter { card in
				card.arrivals.contains { arrival in
					arrival.isExpress == true
				}
			}
			filtered = filtered.map { card in
				var updatedCard = card
				updatedCard.arrivals = card.arrivals.filter { $0.isExpress }
				return updatedCard
			}
		}
		
		filteredCards = filtered
	}
}
