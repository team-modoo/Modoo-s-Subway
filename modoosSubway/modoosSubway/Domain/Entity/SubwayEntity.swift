//
//  SubwayEntity.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/08/03.
//

import Foundation

struct SubwayEntity: Codable {
	let subwayId: String
	let subwayName: String
	let stationId: String
	let stationName: String
	let receiveDate: String
	let receiveTime: String
	let upDownLine: String
	let trainStatus: String
	let isExpress: String
}

struct SubwayStaionEntity: Codable {
    let stationId: String
    let stationName: String
    let lineNumber: String
    let foreignerCode: String
}

