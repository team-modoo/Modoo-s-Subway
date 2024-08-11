//
//  SubwayRepository.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/08/03.
//

import Foundation
import Combine

protocol SubwayRepositoryProtocol {
    func getRealtimePositions(request: SubwayRequestDTO) -> AnyPublisher<SubwayResponseDTO,NetworkError>
}

class SubwayRepository:SubwayRepositoryProtocol {
    
    private let apiService: SubwayAPIServiceProtocol
    
    init(apiService: SubwayAPIServiceProtocol = SubwayAPIService()) {
        self.apiService = apiService
    }
    
    func getRealtimePositions(request: SubwayRequestDTO) -> AnyPublisher<SubwayResponseDTO, NetworkError> {
        return apiService.fetchRealtimePosition(request: request)
            .eraseToAnyPublisher()
    }
    
    
}
