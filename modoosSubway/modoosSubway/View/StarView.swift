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
	@Query private var items: [Item]
	
	var body: some View {
		VStack {
			if items.isEmpty {
				VStack {
					Image("star_circle")
					Text("자주 타는 지하철 노선을 추가해주세요.")
						.font(.pretendard(size: 16, family: .regular))
				}
				.padding(.top, 22)
			} else {
				List {
					ForEach(items) { item in
						NavigationLink {
							Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
						} label: {
							Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
						}
					}
					.onDelete(perform: deleteItems)
				}
			}
		}
		.padding(.horizontal, 20)
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
	StarView()
		.modelContainer(for: Item.self, inMemory: true)
}
