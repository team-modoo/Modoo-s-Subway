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
	@Environment(\.modelContext) private var modelContext
	@State var selectedStation: StationEntity?
	@Query private var starItems: [Star]
	
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
				
                List(vm.cards) { card in
					VStack {
						HStack {
							Text(selectedStation?.lineName() ?? "")
								.font(.pretendard(size: 12, family: .regular))
								.foregroundStyle(.white)
								.padding(.horizontal, 8)
								.padding(.vertical, 5)
								.background(Util.getLineColor(selectedStation?.lineNumber ?? ""))
								.cornerRadius(14)
							
							Text(selectedStation?.stationName ?? "")
								.font(.pretendard(size: 16, family: .medium))
							
							Spacer()
							
							Button(action: {
								starButtonTapped()
							}, label: {
								Image(.iconStar)
							})
							.buttonStyle(BorderlessButtonStyle())
						}
						.padding(.top, 22)
						
						HStack(alignment: .firstTextBaseline) {
							Text(Util.formatArrivalMessage(card.arrivalMessage))
								.font(.pretendard(size: 28, family: .semiBold))
							
							if Util.isArrivalTimeFormat(card.arrivalMessage) {
								Text("후 도착 예정")
									.font(.pretendard(size: 16, family: .regular))
							}
						}
						.frame(width: 300, alignment: .leading)
						.offset(x: -8)
						
						HStack {
							ForEach(card.arrivals, id: \.self) { el in
								Text(el.trainLineName)
									.font(.pretendard(size: 12, family: .medium))
									.padding(.horizontal, 8)
									.padding(.vertical, 5)
									.foregroundStyle(
										Util.getLineColor(selectedStation?.lineNumber ?? "")
									)
									.opacity(0.1)
							}
						}
						.padding(.top, 10)
						
						HStack(alignment: .top, spacing: 0) {
							card.upDownLine == "상행선" || card.upDownLine ==  "외선" ? getStationNamesView(vm.upStationNames) : getStationNamesView(vm.downStationNames)
						}
						.padding(.top, 20)
						
						Spacer()
						
						Text("이 전철은 \(card.upDownLine) 방향 전철입니다.")
							.font(.pretendard(size: 12, family: .bold))
							.frame(width: 350, height: 24, alignment: .center)
							.foregroundStyle(.white)
							.background(
								Util.getLineColor(selectedStation?.lineNumber ?? "")
									.clipShape(
										.rect(
											topLeadingRadius: 0,
											bottomLeadingRadius: 10,
											bottomTrailingRadius: 10,
											topTrailingRadius: 0
										)
									)
							)
					}
					.listRowSeparator(.hidden)
					.padding(.horizontal, 20)
					.frame(width: 350, height: 213)
					.background(
						RoundedRectangle(cornerRadius: 10)
							.stroke(.EDEDED)
					)
				}
				.listStyle(.plain)
				
				Spacer()
			}
		}
		.task {
			if let selectedStation = selectedStation {
				print("task 작업 확인")
				vm.getRealtimeStationArrivals(for: selectedStation.stationName, startIndex: 1, endIndex: 5)
				vm.getSearchSubwayLine(for: selectedStation.lineName(), service: "SearchSTNBySubwayLineInfo", startIndex: 1, endIndex: 100)
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
	
	// MARK: - 지하철 5개의 정거장 라인 뷰
	private func getStationNamesView(_ stationNames: [String]) -> some View {
		ForEach(stationNames, id: \.self) { el in
			VStack {
				Circle()
					.frame(width: 8, height: 8)
					.foregroundColor(Util.getLineColor(selectedStation?.lineNumber ?? ""))
				Text(el)
					.font(.pretendard(size: 12, family: .regular))
					.frame(width: CGFloat(el.count * 12))
			}
			.frame(width: 20)
			
			if el != stationNames.last {
				Rectangle()
					.frame(width: 80, height: 2)
					.padding(.horizontal, -12)
					.padding(.top, 2)
					.foregroundStyle(
						Util.getLineColor(selectedStation?.lineNumber ?? "")
					)
					.opacity(0.3)
			}
		}
	}
	
    // MARK: - 즐겨찾기 추가
	private func starButtonTapped() {
		
	}
	
	private func addStar(item: Star) {
		withAnimation {
			modelContext.insert(item)
			print("add star complete \(item)")
		}
	}
	
	private func deleteStar(item: Star) {
		withAnimation {
			modelContext.delete(item)
			print("delete star complete \(item)")
		}
	}
}
