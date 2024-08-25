//
//  SubwayUseCase.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/08/03.
//

import Foundation
import Combine

protocol SubwayUseCaseProtocol {
    func executeRealtimeStationArrival(request: RealtimeStationArrivalRequestDTO) -> AnyPublisher<ExecutionType<RealtimeStationArrivalResponseDTO>, Never>
    func executeSearchSubwayStation(request: SearchSubwayStationRequestDTO) -> AnyPublisher<ExecutionType<SearchSubwayStationResponseDTO>,Never>
}

class SubwayUseCase: SubwayUseCaseProtocol {
    private let repository: SubwayRepositoryProtocol
    
    init(repository: SubwayRepositoryProtocol) {
        self.repository = repository
    }
	
	// MARK: - 실시간 열차 도착 정보 가져오기
	func executeRealtimeStationArrival(request: RealtimeStationArrivalRequestDTO) -> AnyPublisher<ExecutionType<RealtimeStationArrivalResponseDTO>, Never> {
		return Future<ExecutionType<RealtimeStationArrivalResponseDTO>, Never> { promise in
			self.repository.fetchRealtimeStationArrival(request: request)
				.sink { completion in
					switch completion {
					case .finished:
						break
					case .failure(let error):
						print("Request failed with error: \(error)")
						promise(.success(.error(error)))
					}
				} receiveValue: { (data: RealtimeStationArrivalResponseDTO) in
					promise(.success(.success(data)))
				}
				.cancel()
		}
		.eraseToAnyPublisher()
	}
	
    // MARK: - 지하철역 정보 검색(역명) 가져오기
    func executeSearchSubwayStation(request: SearchSubwayStationRequestDTO) -> AnyPublisher<ExecutionType<SearchSubwayStationResponseDTO>, Never> {
        return Future<ExecutionType<SearchSubwayStationResponseDTO>,Never> { promise in
            self.repository.fetchSearchSubwayStation(request: request)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Request failed with error: \(error)")
                        promise(.success(.error(error)))
                    }
                } receiveValue: { (data: SearchSubwayStationResponseDTO) in
                    promise(.success(.success(data)))
                }
                .cancel()

        }
        .eraseToAnyPublisher()
    }
}
