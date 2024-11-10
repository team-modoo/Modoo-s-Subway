//
//  RequestDTO.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/08/03.
//

import Foundation

// MARK: - 실시간 열차 도착 정보 요청 DTO
struct RealtimeStationArrivalRequestDTO {
	let key: String
	let type: String = "json"
	let service: String = "realtimeStationArrival"
	let startIndex: Int
	let endIndex: Int
	let subwayName: String // "서울"
}

// MARK: - 지하철역 정보 검색(역명&노선별) 요청 DTO
struct SearchSubwayRequestDTO {
	let key: String
	let type: String = "json"
	let service: String // SearchInfoBySubwayNameService, SearchSTNBySubwayLineInfo
	let startIndex: Int
	let endIndex: Int
	var stationCode: String = " "
	var stationName: String = " " // "동대문역사문화공원"
	var stationLine: String = "" // "1호선"
}
