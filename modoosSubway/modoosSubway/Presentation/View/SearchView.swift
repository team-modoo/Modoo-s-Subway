//
//  SearchView.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/07/21.
//

import SwiftUI
import SwiftData

struct SearchView: View {
	// TODO: - DI Container 적용 필요함
	@StateObject var vm: SearchViewModel
	@State var selectedStation: StaionEntity?
	@State var searchStationName: String = ""
	
	var body: some View {
		GeometryReader(content: { geometry in
			List {
				ForEach(vm.stations, id: \.self) { station in
					HStack {
						Text(station.stationName)
							.tint(.black)
						Spacer()
						Text(station.lineNumber)
							.font(.headline)
					}
				}
			}
			.padding(.top, 10)
			.listStyle(.plain)
		})
		.background(.white)
	}
}
