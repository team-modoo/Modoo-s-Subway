//
//  SubwayUseCase.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/08/03.
//

import Foundation
import Combine

protocol FetchRealtimePositionSUseCaseProtocol {
    func execute(request:SubwayRequestDTO) -> AnyPublisher<SubwayResponseDTO,NetworkError>
}

class FetchRealtimePositionUseCase:FetchRealtimePositionSUseCaseProtocol {
    private let repository:SubwayRepositoryProtocol
    
    init(repository: SubwayRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(request: SubwayRequestDTO) -> AnyPublisher<SubwayResponseDTO, NetworkError> {
        return repository.getRealtimePositions(request: request)
    }
    
    
}
