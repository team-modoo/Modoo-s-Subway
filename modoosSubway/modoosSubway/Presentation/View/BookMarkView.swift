//
//  BookMarkView.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/07/21.
//

import SwiftUI
import SwiftData

struct BookMarkView: View {
	@Environment(\.modelContext) private var modelContext
	@Query private var items: [Item]
	
	var body: some View {
		VStack {
			GeometryReader(content: { geometry in
				if items.isEmpty {
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
					List {
						ForEach(items) { item in
							VStack {
								Image(.starCircle)
								Text("자주 타는 지하철 노선을 추가해주세요.")
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
						.onDelete(perform: deleteItems)
					}
				}
			})
		}
		.padding(.top, 22)
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
	BookMarkView()
		.modelContainer(for: Item.self, inMemory: true)
}
