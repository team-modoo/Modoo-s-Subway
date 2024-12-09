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
    @State private var viewType2: FolderType = .Card
    @State private var sortedType: FolderSortedType = .name
   
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
                            StarHeaderView(viewType: $viewType2, sortedType: $sortedType)
                        }
                        //                           .frame(height: 32)
                        //                           .padding(.top, 16)
                        
                        CardView(cards:$cards, viewType: .Star)
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
                }
            })
        }
        .onAppear {
            DataManager.shared.setModelContext(modelContext)
            print("StarView appeared - 저장된 아이템 수: \(starItems.count)")
        }
        .padding(.top, 22)
        .padding(.horizontal, 1)
        
        VStack(spacing: 16) {
            Button(action: {
                print("1111111")
            }) {
                Image("Group 2634")
                    .font(.system(size: 50))
                    .foregroundColor(.blue)
                    .background(Circle().fill(Color.white))
            }
            
            Button(action: {
                print("222222")
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
           
       
   }
}



struct StarHeaderView: View {
    @Binding var viewType: FolderType
    @Binding var sortedType: FolderSortedType
    @State private var expressActiveState: Bool = false
    @State private var selectedDirection: Direction? = nil
    
    enum Direction {
        case upward // 상행/외선
        case downward // 하행/내선
    }

    var body: some View {
        HStack {
            Button {
                  sortedType = .latest
            } label: {
                if sortedType == .latest {
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
                sortedType = .name
            } label: {
                if sortedType == .name {
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
    
    private func changeSortedType(_ type: FolderSortedType) {
        sortedType = type
    }
}


struct StarView2: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var starItems: [Star]
    @State private var cards: [CardViewEntity] = []
    @State private var viewType2: FolderType = .Card
    @State private var sortedType: FolderSortedType = .name
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                GeometryReader { geometry in
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
                                StarHeaderView(viewType: $viewType2, sortedType: $sortedType)
                            }
                            
                            CardView(cards: $cards, viewType: .Star)
                                .onAppear {
                                    cards = starItems.map { $0.subwayCard }
                                }
                        }
                    }
                }
            }
            .onAppear {
                DataManager.shared.setModelContext(modelContext)
            }
            .padding(.top, 22)
            .padding(.horizontal, 1)
            
            // Fixed buttons at bottom right
            VStack(spacing: 16) {
                Button(action: {
                    // First button action
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                        .background(Circle().fill(Color.white))
                        .shadow(radius: 3)
                }
                
                Button(action: {
                    // Second button action
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
}
