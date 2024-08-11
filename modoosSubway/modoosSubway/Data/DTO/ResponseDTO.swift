//
//  ResponseDTO.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/08/11.
//

import Foundation

// MARK: - 실시간 열차 위치 정보 응답 DTO
struct RealtimeSubwayPositionResponseDTO: Codable {
	let errorMessage: ApiResponseData
	let realtimePositionList: [SubwayDTO]
}

struct SubwayDTO: Codable {
	let subwayId: String
	let subwayNm: String
	let statnId: String
	let statnNm: String
	let trainNo: String
	let lastRecptnDt: String
	let recptnDt: String
	let updnLine: String
	let statnTid: String
	let statnTnm: String
	let trainSttus: String
	let directAt: String
	let lstcarAt: String
}

// MARK: - 지하철역 정보 응답 DTO
struct SearchSubwayStationResponseDTO: Codable {
	let errorMessage: ApiResponseData
}

// API 응답의 정보를 담는 DTO (정상,오류메세지,오류타입,total 개수 등)
struct ApiResponseData: Codable {
	let status: Int
	let code: String
	let message: String
	let total: Int
}
