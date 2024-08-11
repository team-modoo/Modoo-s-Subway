//
//  SubwayDTO.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/08/03.
//

import Foundation

// API 요청에 필요한 파라미터를 담는 DTO
struct SubwayRequestDTO {
    let key: String
    let type: String
    let service: String
    let subwayNm: String
    let startIndex: Int
    let endIndex: Int
}

// API 응답에서 지하철 정보를 담는 DTO
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

// API 응답의 정보를 담는 DTO (정상,오류메세지,오류타입,total 개수 등)
struct ApiResponseData: Codable {
    let status: Int
    let code: String
    let message: String
    let total: Int
}


// 전체 API 응답
struct SubwayResponseDTO: Codable {
    let errorMessage: ApiResponseData
    let realtimePositionList: [SubwayDTO]
}
