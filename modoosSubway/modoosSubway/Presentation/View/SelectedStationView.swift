//
//  SelectedStationView.swift
//  modoosSubway
//
//  Created by 김지현 on 8/30/24.
//

import SwiftUI
import SwiftData

struct SelectedStationView: View {
	@Environment(\.dismiss) private var dismiss
    @State private var showMenu = false
	@StateObject var vm: SearchViewModel
	@State var selectedStation: StationEntity?
	@Query private var items: [Item]
	private let stationNames: [String] = ["논현", "반포", "고속터미널", "내방", "이수"]
	
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
							Text(selectedStation?.lineNumber ?? "1호선")
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
								Image(.iconStarYellow)
							})
                            .background(.blue)                           .buttonStyle(BorderlessButtonStyle())
                                Button {
                                    print("iconMore button tapped")
                                    self.showMenu.toggle()
                                } label: {
                                    Image(.iconMore)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                .background(
                                  
                                    VStack {
                                        if showMenu {
//
                                            Button(action: {}) {
                                                HStack {
                                                    Text("폴더 추가하기")
                                                    Image(systemName: "folder")
                                                   
                                                        .font(.pretendard(size: 12, family: .regular))
                                                        .fontWeight(.light)
                                                }
                                            }
                                            .tint(Color.black)
                                            .buttonStyle(BorderlessButtonStyle())
                                            .frame(maxWidth: .infinity)
                                                .padding(5)
                                                .frame(width: 130)
                                                .frame(height: 45)
                                                .background(Color.white)
                                                .cornerRadius(20)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .stroke(.EDEDED, lineWidth: 1)
                                         
                                                )
                                            }
                                        }
                                    
                                        .offset(x: -35, y: 50)
                            
                            )
						}
						.padding(.top, 22)
                        
                        HStack(alignment: .firstTextBaseline) {
                            let arrivalTime = Util.formatArrivalMessage(arrivals.message2)
                            Text("\(arrivalTime)")
                                .font(.pretendard(size: 28, family: .semiBold))
                                .frame(width: 110, alignment: .leading)
                            
                            if Util.isArrivalTimeFormat(arrivals.message2) {
                                Text("후 도착 예정")
                                    .font(.pretendard(size: 16, family: .regular))
                                    .frame(width: 80, alignment: .leading)
                                    .padding(.leading, -40)
                                
                            }
                        }
                        .background(.red)
						.frame(width: 300, alignment: .leading)
						
						Spacer()
						
						HStack(alignment: .top, spacing: 0) {
							ForEach(stationNames, id: \.self) { el in
								VStack {
									Circle()
										.frame(width: 8, height: 8)
										.foregroundColor(.line7)
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
										.foregroundColor(.line7)
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
				
				Spacer()
			}
		}
        .task {
            if let selectedStation = selectedStation {
                vm.getRealtimeStationArrivals(for: selectedStation.stationName, startIndex: 0, endIndex: 5)
                print("task 작업 확인 ")
            }

        }
		.toolbar(.hidden, for: .navigationBar)
    }
}
