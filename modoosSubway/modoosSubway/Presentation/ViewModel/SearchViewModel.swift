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
    @Published var errorMessage: String?
	private var key: String = Util.getApiKey()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(subwayUseCase: SubwayUseCaseProtocol) {
        self.subwayUseCase = subwayUseCase
    }
    
    func getSubwayInfos(for line: String, startIndex: Int, endIndex: Int) {
		let request: RealtimeSubWayPositionRequestDTO = RealtimeSubWayPositionRequestDTO(key: self.key, startIndex: startIndex, endIndex: endIndex, subwayNm: line)
		
		subwayUseCase.executeRealtimeSubwayPosition(request: request)
			.subscribe(on: DispatchQueue.global(qos: .background))
			.map({ [weak self] executionType -> [SubwayEntity] in
				switch executionType {
				case .success(let data):
					print("getSubwayInfos DTO:: \(data)")
					
					let subwayInfos = data.realtimePositionList.map { el in
						return SubwayEntity(subwayId: el.subwayId,
											subwayName: el.subwayNm,
											stationId: el.statnId,
											stationName: el.statnNm,
											receiveDate: el.lastRecptnDt,
											receiveTime: el.recptnDt,
											upDownLine: el.updnLine,
											trainStatus: el.trainSttus,
											isExpress: el.directAt)
					}
					
					return subwayInfos
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
			.sink { value in
				print("getSubwayInfos Entity:: \(value)")
			}
			.store(in: &cancellables)
		
		
    }

    func getSubWayStationInfos(startIndex:Int,endIndex:Int) {
        let request: SearchSubwayStationRequestDTO = SearchSubwayStationRequestDTO(key:self.key,startIndex: startIndex, endIndex: endIndex)
        
        subwayUseCase.executeSearchSubwayStation(request: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .map( { [weak self] executionType -> [SubwayStaionEntity] in
                switch executionType {
                    
                case .success(let data):
                    print("getSubwayStaionInfos DTO:: \(data)")
                    
                    let stationInfos = data.subWayStaionInfo.map { el in
                        return SubwayStaionEntity(stationId: el.STATION_CD,
                                                  stationName: el.STATION_NM,
                                                  lineNumber: el.LINE_NUM,
                                                  foreignerCode: el.FR_CODE)
                    }
                    
                    return stationInfos
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
            .sink { value in
                print("getSubwayStationInfos Entity:: \(value)")
            }
            .store(in: &cancellables)
    }
    
}
