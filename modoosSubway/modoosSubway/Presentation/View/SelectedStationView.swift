//
//  SelectedStationView.swift
//  modoosSubway
//
//  Created by 김지현 on 8/30/24.
//

import SwiftUI
import SwiftData

struct SelectedStationView: View {
	// TODO: - DI Container 적용 필요함
	@StateObject var vm: SelectedStationViewModel = SelectedStationViewModel(subwayUseCase: SubwayUseCase(repository: SubwayRepository()))
	@Environment(\.dismiss) private var dismiss
	@State var selectedStation: StationEntity?
	
	var body: some View {
		NavigationView {
			VStack {
				HStack {
					Button(action: {
						dismiss()
					}) {
						Image(.back)
						Text(selectedStation?.stationName ?? "")
							.padding(.leading, -10)
							.tint(._333333)
					}
					
					Spacer()
				}
				.padding(.horizontal, 20)
				.padding(.top, 22)
				
				CardView(cards: $vm.cards)
				
				Spacer()
			}
		}
		.task {
			if let selectedStation = selectedStation {
				print("task 작업 확인")
				vm.getSearchSubwayLine(for: selectedStation.lineName(), service: "SearchSTNBySubwayLineInfo", startIndex: 1, endIndex: 100) {
					vm.getRealtimeStationArrivals(for: selectedStation.stationName, startIndex: 1, endIndex: 100)
				}
			}
		}
		.onAppear {
			vm.selectedStation = selectedStation
		}
		.toolbar(.hidden, for: .navigationBar)
		.alert("Error", isPresented: $vm.isError) {
			Button("확인", role: .cancel) {}
		} message: {
			Text(vm.errorMessage ?? "")
		}
	}
}
