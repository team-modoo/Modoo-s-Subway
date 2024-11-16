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
	var selectedStation: StationEntity? = nil
	
	@Published var errorMessage: String?
	@Published var isError: Bool = false
	@Published var upStationNames: [String] = []
	@Published var downStationNames: [String] = []
	@Published var cards: [CardViewEntity] = []
	
	init(subwayUseCase: SubwayUseCaseProtocol) {
		self.subwayUseCase = subwayUseCase
	}
	
	func getRealtimeStationArrivals(for subwayName: String, startIndex: Int, endIndex: Int) {
		let request: RealtimeStationArrivalRequestDTO = RealtimeStationArrivalRequestDTO(key: self.key, 
																						 startIndex: startIndex,
																						 endIndex: endIndex,
																						 subwayName: subwayName)
		
		subwayUseCase.executeRealtimeStationArrival(request: request)
			.subscribe(on: DispatchQueue.global(qos: .background))
			.map({ [weak self] executionType -> [ArrivalEntity] in
				switch executionType {
				case .success(let data):
					
					let arrivals: [ArrivalEntity] = data.filter { $0.subwayLine() == self?.selectedStation?.lineName() }
					
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
					self?.isError = true
				default:
					break
				}
				
				return []
			})
			.receive(on: DispatchQueue.main)
			.sink { [weak self] values in
				
				if !values.isEmpty {
					var upArrivalEntities: [ArrivalEntity] = []
					var downArrivalEntities: [ArrivalEntity] = []
					var outArrivalEntities: [ArrivalEntity] = []
					var inArrivalEntities: [ArrivalEntity] = []
					var upArrivals: [Arrival] = []
					var downArrivals: [Arrival] = []
					var outArrivals: [Arrival] = []
					var inArrivals: [Arrival] = []
					var upSubwayCard: CardViewEntity?
					var downSubwayCard: CardViewEntity?
					var outSubwayCard: CardViewEntity?
					var inSubwayCard: CardViewEntity?
					
					values.forEach { el in
						switch el.upDownLine {
						case "상행":
							upArrivalEntities.append(el)
							upArrivals.append(Arrival(arrivalCode: el.arrivalCode, station: el.stationName, trainLineName: el.trainLineName))
						case "하행":
							downArrivalEntities.append(el)
							downArrivals.append(Arrival(arrivalCode: el.arrivalCode, station: el.stationName, trainLineName: el.trainLineName))
						case "외선":
							outArrivalEntities.append(el)
							outArrivals.append(Arrival(arrivalCode: el.arrivalCode, station: el.stationName, trainLineName: el.trainLineName))
						case "내선":
							inArrivalEntities.append(el)
							inArrivals.append(Arrival(arrivalCode: el.arrivalCode, station: el.stationName, trainLineName: el.trainLineName))
						default:
							break
						}
					}
					
					upSubwayCard = CardViewEntity(lineName: self?.selectedStation?.lineName() ?? "",
												  lineNumber: self?.selectedStation?.lineNumber ?? "",
												  arrivalMessage: upArrivalEntities.first?.message2 ?? "",
												  isExpress: upArrivalEntities.first?.isExpress ?? "",
												  arrivals: upArrivals,
												  stationNames: self?.upStationNames ?? [],
												  upDownLine: "상행선",
												  isStar: false,
												  isFolder: false)
					
					downSubwayCard = CardViewEntity(lineName: self?.selectedStation?.lineName() ?? "",
													lineNumber: self?.selectedStation?.lineNumber ?? "",
													arrivalMessage: downArrivalEntities.first?.message2 ?? "",
													isExpress: downArrivalEntities.first?.isExpress ?? "",
													arrivals: downArrivals,
													stationNames: self?.upStationNames ?? [],
													upDownLine: "하행선",
													isStar: false,
													isFolder: false)
					
					outSubwayCard = CardViewEntity(lineName: self?.selectedStation?.lineName() ?? "",
												   lineNumber: self?.selectedStation?.lineNumber ?? "",
												   arrivalMessage: outArrivalEntities.first?.message2 ?? "",
												   isExpress: outArrivalEntities.first?.isExpress ?? "",
												   arrivals: outArrivals,
												   stationNames: self?.upStationNames ?? [],
												   upDownLine: "외선",
												   isStar: false,
												   isFolder: false)
					
					inSubwayCard = CardViewEntity(lineName: self?.selectedStation?.lineName() ?? "",
												  lineNumber: self?.selectedStation?.lineNumber ?? "",
												  arrivalMessage: inArrivalEntities.first?.message2 ?? "",
												  isExpress: inArrivalEntities.first?.isExpress ?? "",
												  arrivals: inArrivals,
												  stationNames: self?.upStationNames ?? [],
												  upDownLine: "내선",
												  isStar: false,
												  isFolder: false)
					
					if let upSubwayCard = upSubwayCard {
						self?.cards.append(upSubwayCard)
					} else if let downSubwayCard = downSubwayCard {
						self?.cards.append(downSubwayCard)
					} else if let outSubwayCard = outSubwayCard {
						self?.cards.append(outSubwayCard)
					} else if let inSubwayCard = inSubwayCard {
						self?.cards.append(inSubwayCard)
					}
					
				} else {
					self?.isError = true
					self?.errorMessage = "데이터가 없습니다."
				}
			}
			.store(in: &cancellables)
	}
	
	func getSearchSubwayLine(for stationLine: String, service: String, startIndex: Int, endIndex: Int) {
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
					self?.isError = true
				default:
					break
				}
				return []
				
			})
			.receive(on: DispatchQueue.main)
			.sink { [weak self] values in
				
				if !values.isEmpty {
					let stations = values.map { $0.stationName }
					let count = 4
					
					let downLastIndex = stations.firstIndex(of: self?.selectedStation?.stationName ?? "" ) ?? 4
					let downStartIndex = max(downLastIndex - count, 0)
					self?.downStationNames = Array(stations[downStartIndex...downLastIndex])
					
					let upStartIndex = stations.firstIndex(of: self?.selectedStation?.stationName ?? "" ) ?? 0
					let upLastIndex = upStartIndex + count
					self?.upStationNames = Array(stations[upStartIndex...upLastIndex])
					
				} else {
					self?.isError = true
					self?.errorMessage = "데이터가 없습니다."
				}
			}
			.store(in: &cancellables)
	}
}
