//
//  SubwayEntity.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/08/03.
//

import Foundation
import SwiftUI

// MARK: - 실시간 열차 도착 정보 Entity
struct ArrivalEntity {
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
struct StationEntity: Hashable, Identifiable {
	let id = UUID()
    let stationId: String
    let stationName: String
    let lineNumber: String
    let foreignerCode: String
    
    func lineColor() -> Color {
        switch self.lineNumber {
        case "01호선":
            return .line1
        case "02호선":
            return .line2
        case "03호선":
            return .line3
        case "04호선":
            return .line4
        case "05호선":
            return .line5
        case "06호선":
            return .line6
        case "07호선":
            return .line7
        case "08호선":
            return .line8
        case "09호선":
            return .line9
        case "공항철도":
            return .lineAirport
        case "수인분당선":
            return .lineBundang
        case "신분당선":
            return .lineNewBundang
        case "경의선":
            return .lineMiddle
        case "신림선":
            return .lineShinlim
        default:
            return ._333333
        }
    }
}

