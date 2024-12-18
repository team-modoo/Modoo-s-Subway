//
//  HomeViewModel.swift
//  modoosSubway
//
//  Created by 임재현 on 12/9/24.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
	
	private let subwayUseCase: SubwayUseCaseProtocol
	private var cancellables = Set<AnyCancellable>()
	
    @Published var selectedTab: ViewType = .Star
    @Published var isSearchViewHidden: Bool = true
    @Published var searchText: String = ""
	@Published var errorMessage: String?
	@Published var isError: Bool = false
	@Published var searchStations: [StationEntity] = []
	var allStations: [StationEntity] = []
	private var key: String = Util.getApiKey()
	
	init(subwayUseCase: SubwayUseCaseProtocol) {
		self.subwayUseCase = subwayUseCase
		self.getAllSubwayStations()
	}
    
	// MARK: - 뷰 타입 변경
    func changeViewType(_ type: ViewType) {
        selectedTab = type
        isSearchViewHidden = true
        searchStations = []
        searchText = ""
    }
    
	// MARK: - 검색 기능
	func handleSearch() {
		if !searchText.isEmpty {
			isSearchViewHidden = false
			
			self.searchStations = self.allStations.filter({ stationEntity in
				stationEntity.stationName.hasPrefix(self.searchText)
			})
		} else {
			isSearchViewHidden = true
			self.searchStations = []
		}
	}
	
	// MARK: - 전체 지하철역 정보 가져오기
	private func getAllSubwayStations() {
		let request: SearchSubwayRequestDTO = SearchSubwayRequestDTO(key:self.key, service: "SearchSTNBySubwayLineInfo", startIndex: 1, endIndex: 800, stationName: "")
		
		print("request\(request)")
		
		subwayUseCase.executeSearchSubwayLine(request: request)
			.subscribe(on: DispatchQueue.global(qos: .background))
			.map( { executionType -> [StationEntity] in
				switch executionType {
				case .success(let data):
					let stations = data.SearchSTNBySubwayLineInfo.row.map { el in
						return StationEntity(stationId: el.STATION_CD,
											 stationName: el.STATION_NM,
											 lineNumber: el.LINE_NUM,
											 foreignerCode: el.FR_CODE)
					}
					
					return stations
				case .error(let error):
					print(error)
				default:
					break
				}
				return []
				
			})
			.receive(on: DispatchQueue.main)
			.sink { [weak self] values in
				self?.allStations = values
			}
			.store(in: &cancellables)
	}
}
