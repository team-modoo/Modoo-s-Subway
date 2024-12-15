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
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var selectedCard: CardViewEntity?
    @State private var countdowns: [UUID: Int] = [:]
    @State private var lastBarvlDts: [UUID: String] = [:]
    var onStarSaved: ((Bool) -> Void)? = nil
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
											.fill(Util.getLineColor(card.lineNumber))
											.opacity(0.1)
									)
								
								Image(.group4)
									.frame(width: 8,height: 8)
									.foregroundStyle(Util.getLineColor(card.lineNumber))
									.offset(y:19)
									.opacity(0.7)
							}
							
							
						}
					}
					
					
					HStack(alignment: .top, spacing: 0) {
						getStationNamesView(card)
					}
					.padding(.top, 4)
					
					Spacer()
					
					if let firstArrival = card.arrivals.first {
						let arrivals = Util.formatTrainLineName(firstArrival.trainLineName)
						Text("이 전철은 \(arrivals) 방향 전철입니다.")
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
					
					
				}
				
				.buttonStyle(PlainButtonStyle())
				.listRowSeparator(.hidden)
				.padding(.horizontal,20)
				.frame(width: 350, height: 213)
				.background(
					RoundedRectangle(cornerRadius: 10)
						.stroke(.EDEDED)
				)
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
					.presentationDetents([.fraction(CGFloat(1/3))])
					.presentationDragIndicator(.visible)
					.presentationCornerRadius(26)
			)
		} else {
			return AnyView(
				AddFolderView(card: card)
					.presentationDetents([.fraction(CGFloat(1/3))])
					.presentationDragIndicator(.visible)
					.presentationCornerRadius(26)
			)
		}
	}
    
    // MARK: - 지하철 5개의 정거장 라인 뷰
    private func getStationNamesView(_ card: CardViewEntity) -> some View {
        ForEach(card.stationNames, id: \.self) { el in
            VStack {
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(Util.getLineColor(card.lineNumber))
                    .opacity(0.7)
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
			}
		}
	}
}
