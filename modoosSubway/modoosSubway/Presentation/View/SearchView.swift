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
	@StateObject var vm: SearchViewModel = SearchViewModel(subwayUseCase: SubwayUseCase(repository: SubwayRepository()))
	
	var body: some View {
		VStack {
			Text("서치뷰")
			
			Button(action: {
				vm.getSubwayInfos(for: "1호선", startIndex: 0, endIndex: 5)
                vm.getSubWayStationInfos(startIndex: 1, endIndex: 5)
			}, label: {
				Text("실시간 열차 위치 정보 API 요청하기 버튼")
			})
		}
	}
}

#Preview {
	SearchView()
}
