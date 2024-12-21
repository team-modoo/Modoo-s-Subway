//
//  SelectedStationView.swift
//  modoosSubway
//
//  Created by 김지현 on 8/30/24.
//

import SwiftUI
import SwiftData

struct SelectedStationView: View {
	
    private let container: DIContainer
    @StateObject var vm: SelectedStationViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
	@Environment(\.dismiss) private var dismiss
	@State var selectedStation: StationEntity?
    @State private var toast: FancyToast? = nil
    
	init(container: DIContainer, selectedStation: StationEntity?) {
        self.container = container
        self.selectedStation = selectedStation
        
        _vm = StateObject(wrappedValue: container.makeSelectedStationViewModel())
    }
	
	var body: some View {
		NavigationView {
			VStack {
				HStack {
					Button(action: {
						dismiss()
					}) {
						Image(.back)
						
						Text(selectedStation?.stationName ?? "")
							.font(.pretendard(size: 18, family: .semiBold))
							.padding(.leading, -10)
							.tint(._333333)
					}
					
					Spacer()
				}
				.padding(.horizontal, 20)
				.padding(.top, 22)
				
				CardListView(cards: $vm.cards, onStarSaved:  { saved in
                    if saved {
                        toast = FancyToast(type: .success, title: "즐겨찾기가 완료되었어요! ")
                    }
                })
				
				Spacer()
			}
		}
		.toastView(toast: $toast, onMoveToStarView: {
			homeViewModel.changeViewType(.Star)
			dismiss()
		})
		.task {
			if let selectedStation = selectedStation {
				vm.getFiveStations {
					if selectedStation.stationName == "총신대입구" || selectedStation.stationName == "이수" {
						vm.getRealtimeStationArrivals(for: "총신대입구(이수)", startIndex: 1, endIndex: 2)
					} else {
						vm.getRealtimeStationArrivals(for: selectedStation.stationName, startIndex: 1, endIndex: 2)
					}
				}
			}
		}
		.onAppear {
			vm.selectedStation = selectedStation
			vm.allStations = homeViewModel.allStations
		}
		.toolbar(.hidden, for: .navigationBar)
		.alert("Error", isPresented: $vm.isError) {
			Button("확인", role: .cancel) {}
		} message: {
			Text(vm.errorMessage ?? "")
		}
	}
}
