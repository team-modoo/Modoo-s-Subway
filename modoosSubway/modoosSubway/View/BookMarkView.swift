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
			Text("북마크")
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
