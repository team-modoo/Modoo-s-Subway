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
	private let stationNames: [String] = ["논현", "반포", "고속터미널", "내방", "이수"]
	
	var body: some View {
		VStack {
			GeometryReader(content: { geometry in
				if items.isEmpty {
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
					List {
						ForEach(items) { item in
							VStack {
								HStack {
									Text("7호선")
										.font(.pretendard(size: 12, family: .regular))
										.foregroundStyle(.white)
										.padding(.horizontal, 8)
										.padding(.vertical, 5)
										.background(.line7)
										.cornerRadius(14)
									
									Text("이수(총신대입구)")
									
									Spacer()
									
									Button(action: {
										
									}, label: {
										Image(.iconStarYellow)
									})
									
									Button(action: {
										
									}, label: {
										Image(.iconMore)
									})
								}
								.padding(.top, 22)
								
								HStack(alignment: .firstTextBaseline) {
									Text("3분 59초")
										.font(.pretendard(size: 28, family: .semiBold))
										.frame(width: 110, alignment: .leading)
									Text("후 도착 예정")
										.font(.pretendard(size: 16, family: .regular))
										.frame(width: 80, alignment: .leading)
										.padding(.leading, -10)
								}
								.frame(width: geometry.size.width - 40, alignment: .leading)
								
								Spacer()
								
								HStack(alignment: .top, spacing: 0) {
									ForEach(stationNames, id: \.self) { el in
										VStack {
											Circle()
												.frame(width: 8, height: 8)
												.foregroundColor(.line7)
											Text(el)
												.font(.pretendard(size: 12, family: .regular))
												.frame(width: CGFloat(el.count * 12))
										}
										.frame(width: 20)
										
										if el != stationNames.last {
											Rectangle()
												.frame(width: 80, height: 2)
												.padding(.horizontal, -12)
												.padding(.top, 2)
												.foregroundColor(.line7)
										}
									}
								}
								.padding(.bottom, 22)
							}
							.padding(.horizontal, 20)
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
		.padding(.horizontal, 1)
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
