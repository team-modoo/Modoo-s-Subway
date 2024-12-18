//
//  SearchView.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/07/21.
//

import SwiftUI
import SwiftData

struct SearchView: View {
	
    let container: DIContainer
    @StateObject var vm: HomeViewModel
	
	var body: some View {
		Group {
			List(vm.searchStations) { station in
				HStack {
					formatSearchText(station.stationName)
						.fixedSize(horizontal: false, vertical: true)
					
					Spacer()
					
					HStack {
						Text(station.lineName())
							.font(.pretendard(size: 14, family: .regular))
							.tint(.white)
					}
					.padding(.horizontal, 14)
					.padding(.vertical, 7.5)
					.background(Capsule().fill(Util.getLineColor(station.lineNumber)))
					.foregroundColor(.white)
				}
				.background(
					NavigationLink("", destination: SelectedStationView(container: container, selectedStation: station))
						.opacity(0)
				)
				.listRowSeparator(.hidden)
				.buttonStyle(PlainButtonStyle())
				.listRowInsets(EdgeInsets(
					top: 24,
					leading: 20,
					bottom: 24,
					trailing: 20
				))
				.listRowBackground(Color.clear)
			}
			.listStyle(.plain)
		}
		.frame(width: .infinity)
		.background(.white)
		.alert("Error", isPresented: $vm.isError) {
			Button("확인", role: .cancel) {}
		} message: {
			Text(vm.errorMessage ?? "")
		}
	}
	
	// MARK: - 검색어 볼드 처리
	private func formatSearchText(_ stationName: String) -> Text {
		let words = stationName.components(separatedBy: " ")
		var formattedText = Text("")
		
		for (index, word) in words.enumerated() {
			// 검색된 단어는 Bold 처리
			if word.contains(vm.searchText) && !vm.searchText.isEmpty {
				let highlightedPart = Text(vm.searchText)
					.font(.pretendard(size: 16, family: .medium))
					.foregroundColor(._5_C_5_C_5_C)
				let remainingPart = Text(word.replacingOccurrences(of: vm.searchText, with: ""))
					.font(.pretendard(size: 16, family: .regular))
					.foregroundColor(._5_C_5_C_5_C)
				formattedText = formattedText + highlightedPart + remainingPart
			} else {
				formattedText = formattedText + Text(word)
					.font(.pretendard(size: 16, family: .regular))
					.foregroundColor(._5_C_5_C_5_C)
			}
			
			// 마지막 단어가 아니면 공백 추가
			if index < words.count - 1 {
				formattedText = formattedText + Text(" ")
			}
		}
		
		return formattedText
	}
}
