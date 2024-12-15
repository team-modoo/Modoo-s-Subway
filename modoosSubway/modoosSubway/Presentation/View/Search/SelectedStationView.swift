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
    @State private var timer: Timer? = nil
	@Environment(\.dismiss) private var dismiss
	@State var selectedStation: StationEntity?
    @State private var toast: FancyToast? = nil
    @State private var apiCallCount = 0
    
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
				
				CardListView(cards: $vm.cards, onStarSaved:  { saved in
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
                print("Initial API call - task")
                apiCallCount += 1
                print("[\(Date())] 총 API 호출 횟수: \(apiCallCount)")
				vm.getSearchSubwayLine(for: selectedStation.lineName(), service: "SearchSTNBySubwayLineInfo", startIndex: 1, endIndex: 100) {
                    apiCallCount += 1
                    print("[\(Date())] 총 API 호출 횟수: \(apiCallCount)")
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
			Button {
				// 타이머 정리
				timer?.invalidate()
				timer = nil
			} label: {
				Text("확인")
			}
		} message: {
			Text(vm.errorMessage ?? "")
		}
	}
    func startTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in  // 15.0 -> 5.0으로 수정
            if let selectedStation = selectedStation {
                print("[\(Date())] Timer triggered")
                
                // 첫 번째 API 호출
                apiCallCount += 1
                print("[\(Date())] SearchSubwayLine API 호출 - 총 횟수: \(apiCallCount)")
                
                vm.getSearchSubwayLine(for: selectedStation.lineName(),
                                     service: "SearchSTNBySubwayLineInfo",
                                     startIndex: 1,
                                     endIndex: 100) {
                    // 두 번째 API 호출
                    apiCallCount += 1
                    print("[\(Date())] RealtimeStationArrivals API 호출 - 총 횟수: \(apiCallCount)")
                    
                    vm.getRealtimeStationArrivals(for: selectedStation.stationName,
                                                startIndex: 1,
                                                endIndex: 100)
                }
            }
        }
    }
}
