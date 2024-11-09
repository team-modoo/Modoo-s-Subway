//
//  SelectedStationViewModel.swift
//  modoosSubway
//
//  Created by 김지현 on 11/9/24.
//

import Foundation
import SwiftUI
import Combine

class SelectedStationViewModel: ObservableObject {
	private let subwayUseCase: SubwayUseCaseProtocol
	private var cancellables = Set<AnyCancellable>()
	private var key: String = Util.getApiKey()
	
	@Published var errorMessage: String?
	@Published var arrivals: [ArrivalEntity] = []
	@Published var stationNames: [String] = []
	
	init(subwayUseCase: SubwayUseCaseProtocol) {
		self.subwayUseCase = subwayUseCase
	}
	
	func getRealtimeStationArrivals(for subwayName: String, startIndex: Int, endIndex: Int) {
		let request: RealtimeStationArrivalRequestDTO = RealtimeStationArrivalRequestDTO(key: self.key, startIndex: startIndex, endIndex: endIndex, subwayName: subwayName)
		
		subwayUseCase.executeRealtimeStationArrival(request: request)
			.subscribe(on: DispatchQueue.global(qos: .background))
			.map({ [weak self] executionType -> [ArrivalEntity] in
				switch executionType {
				case .success(let data):
					let arrivals = data.realtimeArrivalList.map { el in
						return ArrivalEntity(subwayId: el.subwayId,
											 upDownLine: el.updnLine,
											 trainLineName: el.trainLineNm,
											 stationId: el.statnId,
											 stationName: el.statnNm,
											 subwayList: el.subwayList,
											 stationList: el.statnList,
											 isExpress: el.btrainSttus,
											 date: el.recptnDt,
											 message2: el.arvlMsg2,
											 message3: el.arvlMsg3,
											 arrivalCode: el.arvlCd,
											 isLastCar: el.lstcarAt)
					}
					
					return arrivals
				case .error(let error):
					switch error {
					case .invalidURL:
						self?.errorMessage = "잘못된 URL입니다."
					case .noData:
						self?.errorMessage = "데이터를 받을 수 없습니다."
					case .decodingError:
						self?.errorMessage = "데이터 디코딩에 실패했습니다."
					case .serverError(let statusCode):
						self?.errorMessage = "서버 오류: \(statusCode)"
					case .customError(_, let message):
						self?.errorMessage = message
					case .unknownError:
						self?.errorMessage = "알 수 없는 오류가 발생했습니다."
					}
				default:
					break
				}
				
				return []
			})
			.receive(on: DispatchQueue.main)
			.sink { [weak self] value in
				self?.arrivals = value
			}
			.store(in: &cancellables)
	}
	
	func getSearchSubwayLine(for stationLine: String, service: String, startIndex:Int, endIndex:Int) {
		let request: SearchSubwayRequestDTO = SearchSubwayRequestDTO(key:self.key, service: service, startIndex: startIndex, endIndex: endIndex, stationLine: stationLine)
		
		subwayUseCase.executeSearchSubwayLine(request: request)
			.subscribe(on: DispatchQueue.global(qos: .background))
			.map( { [weak self] executionType -> [StationEntity] in
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
					switch error {
					case .invalidURL:
						self?.errorMessage = "잘못된 URL입니다."
					case .noData:
						self?.errorMessage = "데이터를 받을 수 없습니다."
					case .decodingError:
						self?.errorMessage = "데이터 디코딩에 실패했습니다."
					case .serverError(let statusCode):
						self?.errorMessage = "서버 오류: \(statusCode)"
					case .customError(_, let message):
						self?.errorMessage = message
					case .unknownError:
						self?.errorMessage = "알 수 없는 오류가 발생했습니다."
					}
				default:
					break
				}
				return []
				
			})
			.receive(on: DispatchQueue.main)
			.sink { [weak self] value in
				self?.stationNames = value.map { $0.stationName }
			}
			.store(in: &cancellables)
	}
}
