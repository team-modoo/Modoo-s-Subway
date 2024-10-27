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
				
				List(0..<5) { item in
					VStack {
						HStack {
							Text(selectedStation?.lineNumber ?? "1호선")
								.font(.pretendard(size: 12, family: .regular))
								.foregroundStyle(.white)
								.padding(.horizontal, 8)
								.padding(.vertical, 5)
								.background(.line7)
								.cornerRadius(14)
							
							Text(selectedStation?.stationName ?? "")
							
							Spacer()
							
							Button(action: {
								
							}, label: {
								Image(.iconStarYellow)
							})
							
							Button(action: {
								
							}, label: {
								Image(.iconMore)
							})
						}
						.padding(.top, 22)
						
						HStack(alignment: .firstTextBaseline) {
							Text("3분 59초")
								.font(.pretendard(size: 28, family: .semiBold))
								.frame(width: 110, alignment: .leading)
							Text("후 도착 예정")
								.font(.pretendard(size: 16, family: .regular))
								.frame(width: 80, alignment: .leading)
								.padding(.leading, -10)
						}
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
					.frame(width: 300, height: 196)
					.background(
						RoundedRectangle(cornerRadius: 10)
							.stroke(.EDEDED)
					)
				}
				
				Spacer()
			}
		}
		.toolbar(.hidden, for: .navigationBar)
    }
}
