//
//  SearchView.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/07/21.
//

import SwiftUI
import SwiftData

struct SearchView: View {
	@StateObject var vm: SearchViewModel
	
	var body: some View {
		GeometryReader(content: { geometry in
			List(vm.stations) { station in
				NavigationLink(destination: SelectedStationView(selectedStation: station)) {
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
				}
				.listRowSeparator(.hidden)
				.buttonStyle(PlainButtonStyle())
				.listRowInsets(EdgeInsets(
					top: 24,
					leading: 0,
					bottom: 24,
					trailing: 0
				))
				.listRowBackground(Color.clear)
			}
			.padding(.top, 10)
			.listStyle(.plain)
		})
		.background(.white)
		.alert("Error", isPresented: $vm.isError) {
			Button("확인", role: .cancel) {}
		} message: {
			Text(vm.errorMessage ?? "")
		}
	}
}
