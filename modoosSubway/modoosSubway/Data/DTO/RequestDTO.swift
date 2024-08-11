//
//  RequestDTO.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/08/03.
//

import Foundation

// MARK: - 실시간 열차 위치 정보 요청 DTO
struct RealtimeSubWayPositionRequestDTO {
	let key: String
	let type: String = "json"
	let service: String = "realtimePosition"
	let startIndex: Int
	let endIndex: Int
	let subwayNm: String
}

// MARK: - 지하철역 정보 요청 DTO
struct SearchSubwayStationRequestDTO {
	let key: String
	let type: String = "json"
	let service: String = "SearchSTNBySubwayLineInfo"
	let startIndex: Int
	let endIndex: Int
}
