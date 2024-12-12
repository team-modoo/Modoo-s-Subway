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
    @ObservedObject var vm: SearchViewModel
	
	var body: some View {
		Group {
			List(vm.stations) { station in
				HStack {
					Text(station.stationName)
						.font(.pretendard(size: 16, family: .regular))
						.tint(._5_C_5_C_5_C)
					
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
}
