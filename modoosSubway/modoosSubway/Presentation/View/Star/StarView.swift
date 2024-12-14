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
//    @State private var cards: [CardViewEntity] = []
    @State  var viewType2: FolderType = .Card
    @State  var sortedType: StarSortedType = .all
    @State private var expressActiveState = false
    
    @State private var filteredCards: [CardViewEntity] = []
    @State private var showModal = false
    @State private var isRefreshing = false
    @ObservedObject var cardStore: SubwayCardStore
    
    
    
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
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
                        VStack {
                            HStack {
                                StarHeaderView(viewType: $viewType2,
                                               sortedType: $sortedType,
                                               expressActiveState: $expressActiveState)
                            }
                            
                            CardView(cards:$filteredCards, viewType: .Star)
                                .onChange(of: sortedType) { _, newValue in
                                    updateFilteredCards()
                                }
                            
                                .onChange(of: cardStore.cards) { _, _ in
                                    updateFilteredCards()
                                }
                                .onChange(of: expressActiveState) { _, _ in
                                    updateFilteredCards()
                                }

                        }
                    }
                })
            }
            .onAppear {
                DataManager.shared.setModelContext(modelContext)
                print("StarView appeared - 저장된 아이템 수: \(starItems.count)")
                cardStore.loadSavedCards(from: starItems)
                updateFilteredCards()
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
                print("현재 표시되는 카드 수: \(cardStore.cards.count)")
            }
            .padding(.top, 22)
            .padding(.horizontal, 1)
            
            VStack(spacing: 16) {
                Button(action: {
                    print("1111111")
                    self.showModal.toggle()
                }) {
                    Image("Group 2634")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                        .background(Circle().fill(Color.white))
                }
                
                Button(action: {
                    print("222222")
                    isRefreshing = true
                    cardStore.refreshAllCards()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isRefreshing = false
                    }
                }) {
                    Image("Group 2633")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                        .background(Circle().fill(Color.white))
                }
            }
            .padding(.bottom, 30)
            .padding(.trailing, 20)
            
        }
        .sheet(isPresented: $showModal) {
            AlarmSettingView()
                .presentationDetents([.fraction(0.8)])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(30)
        }
    }
    
    private func updateFilteredCards() {
        let allCards = Array(cardStore.cards.values)
            .sorted { $0.stationName < $1.stationName }
        
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

struct StarHeaderView: View {
    @Binding var viewType: FolderType
    @Binding var sortedType: StarSortedType
    @Binding  var expressActiveState: Bool
    @State private var selectedDirection: Direction? = nil
    
    enum Direction {
        case upward // 상행/외선
        case downward // 하행/내선
    }

    var body: some View {
        HStack {
            
            Button {
                  sortedType = .all
                  print("전체")
            } label: {
                if sortedType == .all {
                    Text("전체")
                        .font(.pretendard(size: 16, family: .regular))
                        .foregroundStyle(.black)
                } else {
                    Text("전체")
                        .font(.pretendard(size: 16, family: .regular))
                        .foregroundStyle(.gray)
                }
            }
            
            Rectangle()
                .frame(width: 1,height: 12)
                .foregroundStyle(.gray)
            
            Button {
                  sortedType = .upLine
                print("상행선")
            } label: {
                if sortedType == .upLine {
                    Text("상행선")
                        .font(.pretendard(size: 16, family: .regular))
                        .foregroundStyle(.black)
                } else {
                    Text("상행선")
                        .font(.pretendard(size: 16, family: .regular))
                        .foregroundStyle(.gray)
                }
            }
            
            Rectangle()
                .frame(width: 1,height: 12)
                .foregroundStyle(.gray)
            
            Button {
                sortedType = .downLine
                print("하행선")
            } label: {
                if sortedType == .downLine {
                    Text("하행선")
                        .font(.pretendard(size: 16, family: .regular))
                        .foregroundStyle(.black)
                } else {
                    Text("하행선")
                        .font(.pretendard(size: 16, family: .regular))
                        .foregroundStyle(.gray)
                }
            }
            
            Spacer()
            
            Toggle(isOn: $expressActiveState, label: {
                expressActiveState ? Image(.expressActive) : Image(.expressInactive)
            })
            .toggleStyle(.button)
            .buttonStyle(.plain)
            .padding(.leading, 16)
            
       }
    }
    
    private func changeViewType(_ type: FolderType) {
        viewType = type
    }
    
    private func changeSortedType(_ type: StarSortedType) {
        sortedType = type
    }
}

