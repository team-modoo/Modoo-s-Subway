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
				NavigationLink {
					SelectedStationView(vm: self.vm, selectedStation: station)
				} label: {
					HStack {
						Text(station.stationName)
							.font(.pretendard(size: 16, family: .regular))
							.tint(._5_C_5_C_5_C)
                            .foregroundStyle(.black)
                            .padding(.leading, 16)
						
						Spacer()
						
						HStack {
							Text(station.lineNumber)
								.font(.pretendard(size: 14, family: .regular))
								.tint(.white)
						}
						.padding(.horizontal, 14)
						.padding(.vertical, 7.5)
						.background(Capsule().fill(station.lineColor()))
						.foregroundColor(.white)
					}
				}
				.listRowInsets(EdgeInsets(
					top: 16,
					leading: 0,
					bottom: 16,
					trailing: 0
				))
				.listRowBackground(Color.clear)
			}
			.padding(.top, 10)
			.listStyle(.plain)
		})
		.background(.white)
	}
}
