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
	var allStations: [StationEntity] = []
	@Published var errorMessage: String?
	@Published var isError: Bool = false
	@Published var upStationNames: [String] = []
	@Published var downStationNames: [String] = []
	@Published var cards: [CardViewEntity] = []
	
	init(subwayUseCase: SubwayUseCaseProtocol) {
		self.subwayUseCase = subwayUseCase
	}
	
	// MARK: - 실시간 열차 위치정보 가져오기
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
                    print("arrivals : ------------------\(arrivals)")
					
					return arrivals
					
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
					var upArrivals: [Arrival] = []
					var downArrivals: [Arrival] = []
					var upSubwayCard: CardViewEntity?
					var downSubwayCard: CardViewEntity?
					
					var count: Int = 0
					
					values.forEach { el in
                        print("el----------------\(el.stationName):\(el.barvlDt):\(el.message2):\(el.message3)")
						count += 1
						
						let upDownLine: UpDownLineType? = UpDownLineType(rawValue: el.upDownLine)
						
						switch upDownLine {
						case .Up, .Out:
							upArrivalEntities.append(el)
							upArrivals.append(Arrival(arrivalCode: el.arrivalCode,
													  station: el.stationName,
													  trainLineName: el.trainLineName,
													  barvlDt: el.barvlDt,
													  message2: el.message2,
													  message3: el.message3,
													  isExpress: el.isExpress == "급행"))
						case .Down, .In:
							downArrivalEntities.append(el)
							downArrivals.append(Arrival(arrivalCode: el.arrivalCode,
														station: el.stationName,
														trainLineName: el.trainLineName,
														barvlDt: el.barvlDt,
														message2: el.message2,
														message3: el.message3,
														isExpress: el.isExpress == "급행"))
							
						default:
							break
						}
					}
					
					if values.count == count {
						
						var temp: Int = 0
						
						values.forEach { el in
							
							temp += 1
							
							let upDownLine: UpDownLineType? = UpDownLineType(rawValue: el.upDownLine)
							
							switch upDownLine {
							case .Up, .Out:
								upSubwayCard = CardViewEntity(lineName: self?.selectedStation?.lineName() ?? "",
															  lineNumber: self?.selectedStation?.lineNumber ?? "",
															  arrivalMessage: upArrivalEntities.first?.message2 ?? "",
															  isExpress: upArrivalEntities.first?.isExpress ?? "",
															  arrivals: upArrivals,
															  stationName: self?.selectedStation?.stationName ?? "",
															  stationNames: el.subwayId == "1009" ? self?.downStationNames ?? [] : self?.upStationNames.reversed() ?? [],
															  upDownLine: "상행선",
															  isStar: false,
															  isFolder: false)
							case .Down, .In:
								downSubwayCard = CardViewEntity(lineName: self?.selectedStation?.lineName() ?? "",
																lineNumber: self?.selectedStation?.lineNumber ?? "",
																arrivalMessage: downArrivalEntities.first?.message2 ?? "",
																isExpress: downArrivalEntities.first?.isExpress ?? "",
																arrivals: downArrivals,
																stationName: self?.selectedStation?.stationName ?? "",
																stationNames: el.subwayId == "1009" ? self?.upStationNames.reversed() ?? [] : self?.downStationNames ?? [],
																upDownLine: "하행선",
																isStar: false,
																isFolder: false)
							default:
								break
							}
						}
						
						if values.count == temp {
							self?.cards = [upSubwayCard, downSubwayCard].compactMap { $0 }
						}
					}
					
				} else {
					self?.isError = true
					self?.errorMessage = "데이터가 없습니다."
				}
			}
			.store(in: &cancellables)
	}
	
	// MARK: - 역명 5개 가져오기
	func getFiveStations(completionHandler: @escaping () -> Void) {
		if !allStations.isEmpty {
			let filteredValues: [StationEntity] = allStations.filter { station in
				station.lineNumber == self.selectedStation?.lineNumber
			}
			let orderedValues: [StationEntity] = filteredValues.sorted {
				let num1 = Int($0.foreignerCode.dropFirst()) ?? 0
				let num2 = Int($1.foreignerCode.dropFirst()) ?? 0
				return num1 < num2
			}
			let stations: [String] = orderedValues.map { $0.stationName }
			
			let count: Int = 4
			
			let downLastIndex = stations.firstIndex(of: self.selectedStation?.stationName ?? "" ) ?? 4
			let downStartIndex = max(downLastIndex - count, 0)
			self.downStationNames = Array(stations[safe: downStartIndex...downLastIndex] ?? [])
			
			let upStartIndex = stations.firstIndex(of: self.selectedStation?.stationName ?? "" ) ?? 0
			let upLastIndex = min(upStartIndex + count, stations.count - 1 )
			self.upStationNames = Array(stations[safe: upStartIndex...upLastIndex] ?? [])
			
			completionHandler()
			
		} else {
			self.isError = true
			self.errorMessage = "데이터가 없습니다."
		}
	}
}
