//
//  SubwayUseCase.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/08/03.
//

import Foundation
import Combine

protocol SubwayUseCaseProtocol {
    func executeRealtimeStationArrival(request: RealtimeStationArrivalRequestDTO) -> AnyPublisher<ExecutionType<[ArrivalEntity]>, Never>
    func executeSearchSubwayStation(request: SearchSubwayRequestDTO) -> AnyPublisher<ExecutionType<SearchSubwayStationResponseDTO>,Never>
    func executeSearchSubwayLine(request: SearchSubwayRequestDTO) -> AnyPublisher<ExecutionType<SearchSubwayLineResponseDTO>,Never>
}

class SubwayUseCase: SubwayUseCaseProtocol {
	
    private let repository: SubwayRepositoryProtocol
	private var cancellables = Set<AnyCancellable>()
    
    init(repository: SubwayRepositoryProtocol) {
        self.repository = repository
    }
	
	// MARK: - 실시간 열차 도착 정보 가져오기
	func executeRealtimeStationArrival(request: RealtimeStationArrivalRequestDTO) -> AnyPublisher<ExecutionType<[ArrivalEntity]>, Never> {
		return Future<ExecutionType<[ArrivalEntity]>, Never> { promise in
			self.repository.fetchRealtimeStationArrival(request: request)
				.sink { completion in
					switch completion {
					case .finished:
						break
					case .failure(let error):
						print("Request failed with error: \(error)")
						return promise(.success(.error(error)))
					}
				} receiveValue: { (data: RealtimeStationArrivalResponseDTO) in
					
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
                                             isLastCar: el.lstcarAt, 
                                             barvlDt: el.barvlDt)
					}
					
					return promise(.success(.success(arrivals)))
				}
				.store(in: &self.cancellables)
		}
		.eraseToAnyPublisher()
	}
	
    // MARK: - 지하철역 정보 검색(역명) 가져오기
    func executeSearchSubwayStation(request: SearchSubwayRequestDTO) -> AnyPublisher<ExecutionType<SearchSubwayStationResponseDTO>, Never> {
        return Future<ExecutionType<SearchSubwayStationResponseDTO>,Never> { promise in
            self.repository.fetchSearchSubwayStation(request: request)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Request failed with error: \(error)")
                        return promise(.success(.error(error)))
                    }
                } receiveValue: { (data: SearchSubwayStationResponseDTO) in
                    return promise(.success(.success(data)))
                }
				.store(in: &self.cancellables)

        }
        .eraseToAnyPublisher()
    }
	
	// MARK: - 지하철역 정보 검색(노선별) 가져오기
	func executeSearchSubwayLine(request: SearchSubwayRequestDTO) -> AnyPublisher<ExecutionType<SearchSubwayLineResponseDTO>, Never> {
		return Future<ExecutionType<SearchSubwayLineResponseDTO>,Never> { promise in
			self.repository.fetchSearchSubwayLine(request: request)
				.sink { completion in
					switch completion {
					case .finished:
						break
					case .failure(let error):
						print("Request failed with error: \(error)")
						return promise(.success(.error(error)))
					}
				} receiveValue: { (data: SearchSubwayLineResponseDTO) in
					return promise(.success(.success(data)))
				}
				.store(in: &self.cancellables)
			
		}
		.eraseToAnyPublisher()
	}
}
