//
//  FolderView.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/07/21.
//

import SwiftUI
import SwiftData

struct FolderView: View {
	@Environment(\.modelContext) private var modelContext
	@Query private var items: [Item]
    @State private var viewType: FolderType = .Card
    @State private var sortedType: FolderSortedType = .name
    var item: [Int] = [1,2,3]
	
	var body: some View {
		VStack {
			GeometryReader(content: { geometry in
				if  item.isEmpty {
					VStack {
						Image(.bookmarkCircle)
						Text("자주 타는 지하철 노선을 꾸며보세요")
							.font(.pretendard(size: 16, family: .regular))
							.foregroundStyle(Color("5C5C5C"))
							.padding(.top, 8)
					}
					.frame(width: geometry.size.width, height: 196)
					.background(
						RoundedRectangle(cornerRadius: 10)
							.stroke(.EDEDED)
					)
					
//					VStack {
//						HStack {
//							Text("7호선")
//								.font(.pretendard(size: 16, family: .regular))
//								.foregroundStyle(Color("5C5C5C"))
//								.padding(.top, 8)
//						}
//					}
//					.frame(width: geometry.size.width, height: 196)
//					.background(
//						RoundedRectangle(cornerRadius: 10)
//							.stroke(.EDEDED)
//					)
                } else {
                    VStack {
                        FolderHeaderView(viewType: $viewType,sortedType: $sortedType)
                        //Spacer()
                      
                        if viewType == .Card {
                            ScrollView(showsIndicators: false) {
                                LazyVGrid(columns: [GridItem()],spacing: 16) {
                                    ForEach(item, id: \.self) { item in
                                        FolderCardView()
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 24)
                            }
                        } else {
                            VStack {
                                FolderListView()
                            }
                        }
                      

                    }
               //     .background(.red)
                    
                }
			})
		}
		.padding(.top, 22)
	}
    // MARK: - 폴더 or 즐겨찾기
    private func changeViewType(_ type: FolderType) {
        viewType = type
    }
    
    private func changeSortedType(_ type: FolderSortedType) {
        sortedType = type
    }
	
	private func addItem() {
		withAnimation {
			let newItem = Item(timestamp: Date())
			modelContext.insert(newItem)
		}
	}
	
	private func deleteItems(offsets: IndexSet) {
		withAnimation {
			for index in offsets {
				modelContext.delete(items[index])
			}
		}
	}
}

#Preview {
	FolderView()
		.modelContainer(for: Item.self, inMemory: true)
}


//struct FolderView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Item]
//    @State private var viewType: FolderType = .Card
//    @State private var sortedType: FolderSortedType = .name
//    var item: [Int] = [1,2,3]
//    
//    var body: some View {
//        VStack {
//            GeometryReader(content: { geometry in
//                    VStack {
//                        FolderHeaderView(viewType: viewType,sortedType: sortedType)
//                        
//                        //Spacer()
//                      
//                        if viewType == .Card {
//                            ScrollView(showsIndicators: false) {
//                                LazyVGrid(columns: [GridItem()],spacing: 16) {
//                                    ForEach(item, id: \.self) { item in
//                                        FolderCardView()
//                                    }
//                                }
//                                .padding(.horizontal, 16)
//                                .padding(.vertical, 24)
//                            }
//                        } else {
//                            FolderListView()
//                        }
//                    }
//            })
//        }
//        .padding(.top, 22)
//    }
//    // MARK: - 폴더 or 즐겨찾기
//    private func changeViewType(_ type: FolderType) {
//        viewType = type
//    }
//    
//    private func changeSortedType(_ type: FolderSortedType) {
//        sortedType = type
//    }
//}

