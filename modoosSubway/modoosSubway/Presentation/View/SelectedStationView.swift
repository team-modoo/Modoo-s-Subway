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
				
                List(vm.arrivals) { arrivals in
                    VStack {
						HStack {
							Text(selectedStation?.lineNumber.replacingOccurrences(of: "0", with: "") ?? "")
								.font(.pretendard(size: 12, family: .regular))
								.foregroundStyle(.white)
								.padding(.horizontal, 8)
								.padding(.vertical, 5)
                                .background(selectedStation?.lineColor())
								.cornerRadius(14)
                            
                            Text(arrivals.message3)
							
							Spacer()
							
							Button(action: {
								print("star button tapped")
							}, label: {
								Image(.iconStarYellowBig)
							})
							.buttonStyle(BorderlessButtonStyle())
						}
						.padding(.top, 22)
						
						HStack(alignment: .firstTextBaseline) {
							Text(Util.formatArrivalMessage(arrivals.message2))
								.font(.pretendard(size: 28, family: .semiBold))
							
							if Util.isArrivalTimeFormat(arrivals.message2) {
								Text("후 도착 예정")
									.font(.pretendard(size: 16, family: .regular))
							}
						}
						.frame(width: 300, alignment: .leading)
						.offset(x: -8)
						
						Spacer()
						
						HStack(alignment: .top, spacing: 0) {
							ForEach(vm.stationNames, id: \.self) { el in
								VStack {
									Circle()
										.frame(width: 8, height: 8)
										.foregroundColor(selectedStation?.lineColor())
									Text(el)
										.font(.pretendard(size: 12, family: .regular))
										.frame(width: CGFloat(el.count * 12))
								}
								.frame(width: 20)
								
								if el != vm.stationNames.last {
									Rectangle()
										.frame(width: 80, height: 2)
										.padding(.horizontal, -12)
										.padding(.top, 2)
										.foregroundColor(selectedStation?.lineColor())
								}
							}
						}
						.padding(.bottom, 22)
					}
					.padding(.horizontal, 20)
					.frame(width: 350, height: 196)
					.background(
						RoundedRectangle(cornerRadius: 10)
							.stroke(.EDEDED)
							.border(.F_5_F_5_F_5, width: 2)
					)
				}
				.scrollContentBackground(.hidden)
				.background(.white)
				
				Spacer()
			}
		}
		.task {
			if let selectedStation = selectedStation {
				print("task 작업 확인")
				vm.getRealtimeStationArrivals(for: selectedStation.stationName, startIndex: 1, endIndex: 5)
				vm.getSearchSubwayLine(for: selectedStation.lineNumber.replacingOccurrences(of: "0", with: ""), service: "SearchSTNBySubwayLineInfo", startIndex: 1, endIndex: 5)
			}
		}
		.toolbar(.hidden, for: .navigationBar)
	}
}
