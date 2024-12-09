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
	func fetchRealtimeStationArrival(request: RealtimeStationArrivalRequestDTO) -> AnyPublisher<RealtimeStationArrivalResponseDTO, NetworkError>
    func fetchSearchSubwayStation(request: SearchSubwayRequestDTO) -> AnyPublisher<SearchSubwayStationResponseDTO,NetworkError>
    func fetchSearchSubwayLine(request: SearchSubwayRequestDTO) -> AnyPublisher<SearchSubwayLineResponseDTO,NetworkError>
}

class SubwayRepository: SubwayRepositoryProtocol {
	// MARK: - 실시간 열차 도착 정보 API 요청
	func fetchRealtimeStationArrival(request: RealtimeStationArrivalRequestDTO) -> AnyPublisher<RealtimeStationArrivalResponseDTO, NetworkError> {
		return Future<RealtimeStationArrivalResponseDTO, NetworkError> { promise in
			AF.request(SubwayAPI.RealtimeSubWayPosition(request))
				.responseDecodable(of: RealtimeStationArrivalResponseDTO.self) { response in
					let statusCode = response.response?.statusCode ?? 0
					
					print("*[실시간 열차 도착 정보 API 요청 status code] \(statusCode)")
					print(JSON(response.data as Any))
					
					switch response.result {
					case .success(let data):
						if data.errorMessage.code != "INFO-000" {
							return promise(.failure(
								NetworkError.customError(
									code: "\(data.errorMessage.status)",
									message: data.errorMessage.message
								)
							))
						}
						return promise(.success(data))
					case .failure(_):
						return promise(.failure(.serverError(statusCode)))
					}
				}
		}
		.eraseToAnyPublisher()
	}
	
    // MARK: - 지하철역 정보 검색(역명) API 요청
    func fetchSearchSubwayStation(request: SearchSubwayRequestDTO) -> AnyPublisher<SearchSubwayStationResponseDTO, NetworkError> {
        return Future<SearchSubwayStationResponseDTO,NetworkError> { promise in
            AF.request(SubwayAPI.SearchSubwayStation(request))
                .responseDecodable(of: SearchSubwayStationResponseDTO.self) { response in
                    let statusCode = response.response?.statusCode ?? 0
                    
                    print("*[지하철역 정보 검색(역명) API 요청 status code] \(statusCode)")
                    print(JSON(response.data as Any),"222222")
                    
                    switch response.result {
                    case .success(let data):
						if data.SearchInfoBySubwayNameService.RESULT.CODE != "INFO-000" {
                            return promise(.failure(
                                NetworkError.customError(
									code: data.SearchInfoBySubwayNameService.RESULT.CODE,
									message: data.SearchInfoBySubwayNameService.RESULT.MESSAGE
                                )
                            ))
                        }
                        return promise(.success(data))
                    case .failure(_):
                        return promise(.failure(.serverError(statusCode)))
                    }
                    
                }
        }
        .eraseToAnyPublisher()
    }

	// MARK: - 지하철역 정보 검색(노선별) API 요청
	func fetchSearchSubwayLine(request: SearchSubwayRequestDTO) -> AnyPublisher<SearchSubwayLineResponseDTO, NetworkError> {
		return Future<SearchSubwayLineResponseDTO,NetworkError> { promise in
			AF.request(SubwayAPI.SearchSubwayLine(request))
				.responseDecodable(of: SearchSubwayLineResponseDTO.self) { response in
					let statusCode = response.response?.statusCode ?? 0
					
					print("*[지하철역 정보 검색(노선별) API 요청 status code] \(statusCode)")
					print(JSON(response.data as Any))
					
					switch response.result {
					case .success(let data):
						if data.SearchSTNBySubwayLineInfo.RESULT.CODE != "INFO-000" {
							return promise(.failure(
								NetworkError.customError(
									code: data.SearchSTNBySubwayLineInfo.RESULT.CODE,
									message: data.SearchSTNBySubwayLineInfo.RESULT.MESSAGE
								)
							))
						}
						return promise(.success(data))
					case .failure(_):
						return promise(.failure(.serverError(statusCode)))
					}
					
				}
		}
		.eraseToAnyPublisher()
	}
}
