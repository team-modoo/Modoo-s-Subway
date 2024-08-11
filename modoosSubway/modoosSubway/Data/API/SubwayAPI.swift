//
//  SubwayAPI.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/08/03.
//

import Foundation
import Combine

protocol SubwayAPIServiceProtocol {
    func fetchRealtimePosition(request: SubwayRequestDTO) -> AnyPublisher<SubwayResponseDTO, NetworkError>
}

class SubwayAPIService: SubwayAPIServiceProtocol {
    
    func fetchRealtimePosition(request: SubwayRequestDTO) -> AnyPublisher<SubwayResponseDTO, NetworkError> {
        guard let apiKey = Configuration.shared.apiKey,
              let baseURL = Configuration.shared.baseURL else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        let urlString = "\(baseURL)\(apiKey)/\(request.type)/\(request.service)/\(request.startIndex)/\(request.endIndex)/\(request.subwayNm)"
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> SubwayResponseDTO in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.unknownError
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.serverError(httpResponse.statusCode)
                }
                
                let decoder = JSONDecoder()
                let subwayResponse = try decoder.decode(SubwayResponseDTO.self, from: data)
                
                if subwayResponse.errorMessage.code != "INFO-000" {
                    throw NetworkError.customError(
                        code: subwayResponse.errorMessage.status,
                        message: subwayResponse.errorMessage.message
                    )
                }
                
                return subwayResponse
            }
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                }
                return NetworkError.unknownError
            }
            .eraseToAnyPublisher()
    }
}
