//
//  SubwayUseCase.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/08/03.
//

import Foundation
import Combine

protocol SubwayUseCaseProtocol {
    func executeRealtimeSubwayPosition(request: RealtimeSubWayPositionRequestDTO) -> AnyPublisher<ExecutionType<RealtimeSubwayPositionResponseDTO>, Never>
}

class SubwayUseCase: SubwayUseCaseProtocol {
    private let repository: SubwayRepositoryProtocol
    
    init(repository: SubwayRepositoryProtocol) {
        self.repository = repository
    }
	
	// MARK: - 실시간 열차 위치 정보 가져오기
	func executeRealtimeSubwayPosition(request: RealtimeSubWayPositionRequestDTO) -> AnyPublisher<ExecutionType<RealtimeSubwayPositionResponseDTO>, Never> {
		return Future<ExecutionType<RealtimeSubwayPositionResponseDTO>, Never> { promise in
			self.repository.fetchRealtimeSubwayPosition(request: request)
				.sink { completion in
					switch completion {
					case .finished:
						break
					case .failure(let error):
						print("Request failed with error: \(error)")
						promise(.success(.error(error)))
					}
				} receiveValue: { (data: RealtimeSubwayPositionResponseDTO) in
					promise(.success(.success(data)))
				}
				.cancel()
		}
		.eraseToAnyPublisher()
	}
}
