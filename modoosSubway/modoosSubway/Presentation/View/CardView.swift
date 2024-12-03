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
    var onStarSaved: ((Bool) -> Void)? = nil
    let folder: Folder?

    var isEditingMode: Bool
    var onOrderChanged: (([CardViewEntity]) -> Void)?
    
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
                        card.isStar ?  Image(.iconStarYellowBig) : Image(.iconStar)
                    })
                    .buttonStyle(BorderlessButtonStyle())
                    
                    if let _ = viewType {
                        // MARK: - 더보기 버튼
                        Button(action: {
                            selectedCard = card
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
                .background(.red)
                
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
            .padding(.horizontal,20)
            .frame(width: 350, height: 213)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.EDEDED)
            )
        }
            .onMove(perform: isEditingMode ? { from, to in  // 편집 모드일 때만 이동 가능
                           cards.move(fromOffsets: from, toOffset: to)
                           onOrderChanged?(cards)
                       } : nil)

        }
        
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .environment(\.editMode, .constant(isEditingMode ? .active : .inactive))
        .sheet(item: $selectedCard) { card in
            if let folder = folder {
                MoreMenuListView(card: card,folder: folder)
                        .presentationDetents([.fraction(1/4)])
                        .presentationDragIndicator(.visible)
                        .presentationCornerRadius(26)
             
               
            } else {
                // StarView에서 열었을 때
                AddFolderView(card: card)  // folder 없이 호출
                    .presentationDetents([.fraction(0.5)])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(26)
            }
           
        }
        .alert("알림", isPresented: $showAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(alertMessage)
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
            if !cards[index].isStar {
                let descriptor = FetchDescriptor<Star>()
                if let stars = try? modelContext.fetch(descriptor) {
                    let isDuplicate = stars.contains { star in
                        let card = star.subwayCard
                        return card.stationNames == item.stationNames &&
                        card.lineNumber == item.lineNumber &&
                        card.upDownLine == item.upDownLine &&
                        card.isExpress == item.isExpress
                    }
                    
                    if isDuplicate {
                        alertMessage = "\(item.stationName) \(item.upDownLine)은(는)\n이미 즐겨찾기에 저장되어 있습니다"
                        showAlert = true
                        return
                    }
                }
                
                cards[index].isStar.toggle()
                let star = Star(subwayCard: cards[index])
                DataManager.shared.addStar(item: star)
                onStarSaved?(true)
                
                
            } else {
                cards[index].isStar.toggle()
                let descriptor = FetchDescriptor<Star>()
                if let stars = try? modelContext.fetch(descriptor),
                   let starToDelete = stars.first(where: { $0.subwayCard == item }) {
                    DataManager.shared.deleteStar(item: starToDelete)
                }
            }
        }
    }
}


//struct CardView: View {
//    // ... 기존 프로퍼티들 ...
//    
//    var body: some View {
//        List {
//            ForEach(cards) { card in
//                VStack {
//                    // ... 카드 내용 ...
//                }
//                .buttonStyle(PlainButtonStyle())
//                .listRowSeparator(.hidden)
//                .padding(.horizontal, isEditingMode ? 20 : 0)  // 편집 모드일 때만 왼쪽 패딩
//                .frame(width: 350, height: 213)
//                .background(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(.EDEDED)
//                )
//            }
//            .onMove(perform: isEditingMode ? { from, to in
//                cards.move(fromOffsets: from, toOffset: to)
//                onOrderChanged?(cards)
//            } : nil)
//        }
//        .listStyle(.plain)
//        .scrollIndicators(.hidden)
//        .environment(\.editMode, .constant(isEditingMode ? .active : .inactive))
//        // 편집 모드가 아닐 때는 중앙 정렬
//        .frame(maxWidth: .infinity, alignment: isEditingMode ? .leading : .center)
//    }
//}
