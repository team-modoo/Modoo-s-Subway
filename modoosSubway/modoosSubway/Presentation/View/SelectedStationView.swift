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
    private let container: DIContainer
    @StateObject var vm: SelectedStationViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State private var timer: Timer? = nil
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
							.padding(.leading, -10)
							.tint(._333333)
					}
					
					Spacer()
				}
				.padding(.horizontal, 20)
				.padding(.top, 22)
				
                CardView(cards: $vm.cards, onStarSaved:  { saved in
                    if saved {
                        toast = FancyToast(type: .success, title: "즐겨찾기가 완료되었어요! ")
                    }
                })
				
				Spacer()
			}
		}
        .toastView(toast: $toast,onMoveToStarView: {
            homeViewModel.changeViewType(.Star)
                            dismiss()
        })

		.task {
			if let selectedStation = selectedStation {
				print("task 작업 확인")
				vm.getSearchSubwayLine(for: selectedStation.lineName(), service: "SearchSTNBySubwayLineInfo", startIndex: 1, endIndex: 100) {
					vm.getRealtimeStationArrivals(for: selectedStation.stationName, startIndex: 1, endIndex: 100)
				}
			}
            // 타이머 시작
            startTimer()
		}
		.onAppear {
			vm.selectedStation = selectedStation
            print("SELECTED VIEW INIT()")
		}
        .onDisappear {
                   // 뷰가 사라질 때 타이머 정리
                   timer?.invalidate()
                   timer = nil
               }
		.toolbar(.hidden, for: .navigationBar)
		.alert("Error", isPresented: $vm.isError) {
			Button("확인", role: .cancel) {}
		} message: {
			Text(vm.errorMessage ?? "")
		}
	}
    func startTimer() {
           // 기존 타이머가 있다면 무효화
           timer?.invalidate()
           
           // 5초마다 실행되는 타이머 생성
           timer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { _ in
               if let selectedStation = selectedStation {
                   vm.getSearchSubwayLine(for: selectedStation.lineName(),
                                        service: "SearchSTNBySubwayLineInfo",
                                        startIndex: 1,
                                        endIndex: 100) {
                       vm.getRealtimeStationArrivals(for: selectedStation.stationName,
                                                   startIndex: 1,
                                                   endIndex: 100)
                   }
               }
           }
       }
}
