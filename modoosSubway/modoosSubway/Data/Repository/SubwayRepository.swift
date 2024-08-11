//
//  SubwayRepository.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/08/03.
//

import Alamofire
import Combine
import SwiftyJSON

protocol SubwayRepositoryProtocol {
	func fetchRealtimeSubwayPosition(request: RealtimeSubWayPositionRequestDTO) -> AnyPublisher<RealtimeSubwayPositionResponseDTO, NetworkError>
}

class SubwayRepository: SubwayRepositoryProtocol {
	// MARK: - 실시간 열차 위치 정보 API 요청
	func fetchRealtimeSubwayPosition(request: RealtimeSubWayPositionRequestDTO) -> AnyPublisher<RealtimeSubwayPositionResponseDTO, NetworkError> {
		return Future<RealtimeSubwayPositionResponseDTO, NetworkError> { promise in
			AF.request(SubwayAPI.RealtimeSubWayPosition(request))
				.responseDecodable(of: RealtimeSubwayPositionResponseDTO.self) { response in
					let statusCode = response.response?.statusCode ?? 0
					
					print("*[실시간 열차 위치 정보 API 요청 status code] \(statusCode)")
					print(JSON(response.data as Any))
					
					switch response.result {
					case .success(let data):
						if data.errorMessage.code != "INFO-000" {
							return promise(.failure(
								NetworkError.customError(
									code: data.errorMessage.status,
									message: data.errorMessage.message
								)
							))
						}
						return promise(.success(data))
					case .failure(let error):
						return promise(.failure(.serverError(statusCode)))
					}
				}
		}
		.eraseToAnyPublisher()
	}
}
