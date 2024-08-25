//
//  SubwayEntity.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/08/03.
//

import Foundation

// MARK: - 실시간 열차 도착 정보 Entity
struct ArrivalEntity: Codable {
	let subwayId: String
	let upDownLine: String
	let trainLineName: String
	let stationId: String
	let stationName: String
	let subwayList: String
	let stationList: String
	let isExpress: String // btrainSttus
	let date: String
	let message2: String
	let message3: String
	let arrivalCode: String // arvlCd - 도착코드 (0:진입, 1:도착, 2:출발, 3:전역출발, 4:전역진입, 5:전역도착, 99:운행중)
	let isLastCar: String // lstcarAt - 막차여부 (1:막차, 0:아님)
}

// MARK: - 지하철역 정보 검색(역명) Entity
struct StaionEntity: Codable {
    let stationId: String
    let stationName: String
    let lineNumber: String
    let foreignerCode: String
}

