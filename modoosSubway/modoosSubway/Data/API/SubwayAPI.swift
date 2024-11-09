//
//  SubwayAPI.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/08/03.
//

import Alamofire
import Combine

enum SubwayAPI {
	// MARK: - 실시간 열차 도착 정보 API
	case RealtimeSubWayPosition(_ request: RealtimeStationArrivalRequestDTO)
	// MARK: - 지하철역 정보 검색(역명) API
	case SearchSubwayStation(_ request: SearchSubwayRequestDTO)
	// MARK: - 지하철역 정보 검색(노선별) API
	case SearchSubwayLine(_ request: SearchSubwayRequestDTO)
}

extension SubwayAPI: Router, URLRequestConvertible {
	var baseURL: String {
		switch self {
		case .RealtimeSubWayPosition:
			return "http://swopenapi.seoul.go.kr"
		case .SearchSubwayStation, .SearchSubwayLine:
			return "http://openapi.seoul.go.kr:8088"
		}
	}
	
	var path: String {
		switch self {
		case .RealtimeSubWayPosition(let request):
			let path: String = "/api/subway/\(request.key)/\(request.type)/\(request.service)/\(request.startIndex)/\(request.endIndex)/\(request.subwayName)"
			
			print(path)
			
			if let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
				print(encodedPath)
				return encodedPath
			} else {
				print("Failed to encode path")
				return path
			}
		case .SearchSubwayStation(let request):
			let path: String = "/\(request.key)/\(request.type)/\(request.service)/\(request.startIndex)/\(request.endIndex)/\(request.stationName)"
			
			print(path)
			
			if let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
				print(encodedPath)
				return encodedPath
			} else {
				print("Failed to encode path")
				return path
			}
		case .SearchSubwayLine(let request):
			let path: String = "/\(request.key)/\(request.type)/\(request.service)/\(request.startIndex)/\(request.endIndex)/\(request.stationCode)/\(request.stationName)/\(request.stationLine)"
			
			print(path)
			
			if let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
				print(encodedPath)
				return encodedPath
			} else {
				print("Failed to encode path")
				return path
			}
				
		}
	}
	
	var method: Alamofire.HTTPMethod {
		switch self {
		case .RealtimeSubWayPosition, .SearchSubwayStation, .SearchSubwayLine:
			return .get
		}
	}
	
	var headers: [String : String]? {
		return nil
	}
	
	var parameters: [String : Any]? {
		return nil
	}
	
	var encoding: Alamofire.ParameterEncoding? {
		return nil
	}
	
	func asURLRequest() throws -> URLRequest {
		let url = URL(string: baseURL + path)
		var request = URLRequest(url: url!)
		
		request.method = method
		
		if let headers = headers {
			request.headers = HTTPHeaders(headers)
		}
		
		if let encoding = encoding {
			return try encoding.encode(request, with: parameters)
		}
		
		return request
	}
}
