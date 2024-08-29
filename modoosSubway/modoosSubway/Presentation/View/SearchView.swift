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
                            .font(.pretendard(size: 16, family: .regular))
                            .tint(._5_C_5_C_5_C)
                        
						Spacer()
                        
                        HStack {
                            Text(station.lineNumber)
                                .font(.pretendard(size: 14, family: .regular))
                                .tint(.white)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7.5)
                        .background(Capsule().fill(.orange))
                        .foregroundColor(.white)
					}
				}
			}
			.padding(.top, 10)
			.listStyle(.plain)
		})
		.background(.white)
	}
}
