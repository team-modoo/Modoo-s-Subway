//
//  FolderCardView.swift
//  modoosSubway
//
//  Created by 임재현 on 11/10/24.
//

import SwiftUI
import SwiftData

struct FolderCardView: View {
    @State private var showModal = false
    let folder: Folder
    
    private var cardHeight: CGFloat {
        folder.backgroundImage == nil ? 140 : 196
    }
    
    var body: some View {
        ZStack {
            NavigationLink(destination: FilteredStarView(folder: folder)) {
                ZStack {
                    FolderBackgroundImage(imageString: folder.backgroundImage)
                        .frame(width: 340, height: cardHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    VStack(alignment: .leading) {
                        HStack {
                            HStack {
                                ForEach(folder.lineNumber, id: \.self) { line in
                                    Text("\(line)")
                                        .font(.pretendard(size: 14, family: .regular))
                                        .tint(.white)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 7.5)
                                        .background(Capsule().fill(Util.getLineColor(line)))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0))
                            
                            Spacer()
                        }
                        
                        Spacer()
                        
                        Text("\(folder.title)")
                            .font(.pretendard(size: 24, family: .bold))
                            .foregroundStyle(.white)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 16, trailing: 0))
                    }
                    .frame(width: 340, height: cardHeight)
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showModal.toggle()
                    } label: {
                        Image("icon_more")
//                            .background(.red)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
                    }
                }
                Spacer()
            }
            .frame(width: 340, height: cardHeight)
        }
        .sheet(isPresented: $showModal) {
            EditFolderView(folder: folder)
                .presentationDetents([.fraction(1/4)])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(30)
        }
    }
}
struct FilteredStarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var starItems: [Star]
    @State private var cards: [CardViewEntity] = []
    @State private var isLoading = true
    @Environment(\.dismiss) var dismiss

    let folder: Folder
    let isEditingMode: Bool
    
    init(folder:Folder, isEditingMode:Bool = false) {
        self.folder = folder
        self.isEditingMode = isEditingMode
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .font(.system(size: 20))
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
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.white)
                
                GeometryReader { geometry in
                    if isLoading {
                        // 로딩 상태 표시
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if cards.isEmpty {
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
                    } else {
                        HStack {
                            if !isEditingMode {
                                Spacer()
                            }
                            CardView(cards: $cards, viewType: .Star,isEditingMode: isEditingMode,folder: folder) { updatedCards in
                                // 순서가 변경될 때마다 호출됨
                                let newOrder = updatedCards.map { $0.id }
                                DataManager.shared.updateFolderCardOrder(folder, newOrder: newOrder, context: modelContext)
                            }
                            .padding(.leading,10)
                            
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                loadCards()
            }
            .padding(.top, 22)
            .padding(.horizontal, 1)
        if !cards.isEmpty && !isLoading {
            VStack(spacing: 16) {
                Button(action: {
                   print("333333")
                }) {
                    Image("Group 2634")
                        .foregroundColor(.blue)
                        .background(Circle().fill(Color.white))
                }
                
                Button(action: {
                    print("44444")
                }) {
                    Image("Group 2633")
                        .foregroundColor(.blue)
                        .background(Circle().fill(Color.white))

                }
            }
            .padding(.bottom, 30)
            .padding(.trailing, 20)
            
        }
        
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
}


struct FilteredStarView2: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var starItems: [Star]
    @State private var cards: [CardViewEntity] = []
    @State private var isLoading = true
    @Environment(\.dismiss) var dismiss

    let folder: Folder
    let isEditingMode: Bool
    
    init(folder: Folder, isEditingMode: Bool = false) {
        self.folder = folder
        self.isEditingMode = isEditingMode
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .font(.system(size: 20))
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
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.white)
                
                GeometryReader { geometry in
                    if isLoading {
                        // 로딩 상태 표시
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if cards.isEmpty {
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
                    } else {
                        HStack {
                            if !isEditingMode {
                                Spacer()
                            }
                            CardView(cards: $cards, viewType: .Star, isEditingMode: isEditingMode, folder: folder) { updatedCards in
                                // 순서가 변경될 때마다 호출됨
                                let newOrder = updatedCards.map { $0.id }
                                DataManager.shared.updateFolderCardOrder(folder, newOrder: newOrder, context: modelContext)
                            }
                            .padding(.leading, 10)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                loadCards()
            }
            .padding(.top, 22)
            .padding(.horizontal, 1)
            
            // 플로팅 버튼들
            VStack(spacing: 16) {
                Button(action: {
                    // 첫 번째 버튼 동작
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                        .background(Circle().fill(Color.white))
                        .shadow(radius: 3)
                }
                
                Button(action: {
                    // 두 번째 버튼 동작
                }) {
                    Image(systemName: "folder.fill.badge.plus")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                        .background(Circle().fill(Color.white))
                        .shadow(radius: 3)
                }
            }
            .padding(.bottom, 30)
            .padding(.trailing, 20)
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
}
