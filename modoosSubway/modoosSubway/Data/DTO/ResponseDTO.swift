//
//  ResponseDTO.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/08/11.
//

import Foundation

// MARK: - 실시간 열차 도착 정보 응답 DTO
struct RealtimeStationArrivalResponseDTO: Codable {
	let errorMessage: ErrorMessage
	let realtimeArrivalList: [RealtimeArrivalDTO]
}

// MARK: - 정상, 오류메세지, 오류타입, total 개수
struct ErrorMessage: Codable {
	let status: Int
	let code: String
	let message: String
	let total: Int
}

struct RealtimeArrivalDTO: Codable {
	let subwayId: String
	let updnLine: String // "상행"
	let trainLineNm: String // "당고개행 - 회현방면"
	let statnId: String
	let statnNm: String // "서울"
	let trnsitCo: String // "4"
	let ordkey: String // "01000당고개0"
	let subwayList: String // "1001,1004,1063,1065"
	let statnList: String // 1001000133,1004000426,1063080313,1065006501"
	let btrainSttus: String // "일반"
	let recptnDt: String // "2024-08-25 11:22:34"
	let arvlMsg2: String // "서울 진입"
	let arvlMsg3: String // "서울"
	let arvlCd: String // "1"
	let lstcarAt: String // "0"
}

// MARK: - 지하철역 정보 검색(역명) 응답 DTO
struct SearchSubwayStationResponseDTO: Codable {
	let SearchInfoBySubwayNameService: SearchInfoBySubwayNameService
}

struct SearchInfoBySubwayNameService: Codable {
	let list_total_count: Int
	let RESULT: RESULT
    let row: [StationInfoDTO]
}

struct RESULT: Codable {
	let CODE: String // "INFO-000"
	let MESSAGE: String // "정상 처리되었습니다"
}

struct StationInfoDTO:Codable {
    let STATION_CD: String
    let STATION_NM: String
    let LINE_NUM: String
    let FR_CODE: String
}
