//
//  SearchViewModel.swift
//  modoosSubway
//
//  Created by 임재현 on 8/11/24.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    private let subwayUseCase: SubwayUseCaseProtocol
	private var cancellables = Set<AnyCancellable>()
	private var key: String = Util.getApiKey()
	
    @Published var errorMessage: String?
    @Published var isError: Bool = false
    @Published var stations: [StationEntity] = []
    
    init(subwayUseCase: SubwayUseCaseProtocol) {
        self.subwayUseCase = subwayUseCase
    }

	func getSearchSubwayStations(for stationName: String, service: String, startIndex:Int, endIndex:Int) {
		let request: SearchSubwayRequestDTO = SearchSubwayRequestDTO(key:self.key, service: service, startIndex: startIndex, endIndex: endIndex, stationName: stationName)
        
        print("request\(request)")
        
        subwayUseCase.executeSearchSubwayStation(request: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .map( { [weak self] executionType -> [StationEntity] in
                switch executionType {
                case .success(let data):
					let stations = data.SearchInfoBySubwayNameService.row.map { el in
						return StationEntity(stationId: el.STATION_CD,
											stationName: el.STATION_NM,
											lineNumber: el.LINE_NUM,
											foreignerCode: el.FR_CODE)
					}
					
                    return stations
                case .error(let error):
                    switch error {
                    case .invalidURL:
                        self?.errorMessage = "잘못된 URL입니다."
                    case .noData:
                        self?.errorMessage = "데이터를 받을 수 없습니다."
                    case .decodingError:
                        self?.errorMessage = "데이터 디코딩에 실패했습니다."
                    case .serverError(_):
                        self?.errorMessage = "현재 해당하는 데이터가 없습니다."
                    case .customError(_, let message):
                        self?.errorMessage = message
                    case .unknownError:
                        self?.errorMessage = "알 수 없는 오류가 발생했습니다."
                    }
					
					self?.isError = true
					self?.stations = []
                default:
                    break
                }
                return []
            
            })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] values in
				if !values.isEmpty {
					self?.stations = values
				} else {
					self?.errorMessage = "데이터가 없습니다."
					self?.isError = true
					self?.stations = []
				}
            }
            .store(in: &cancellables)
    }
}
