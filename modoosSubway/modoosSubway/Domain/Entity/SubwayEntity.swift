//
//  SubwayEntity.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/08/03.
//

import Foundation
import SwiftUI

// MARK: - 실시간 열차 도착 정보 Entity
struct ArrivalEntity: Hashable, Identifiable {
    var id =  UUID()
	let subwayId: String
	let upDownLine: String
	let trainLineName: String
	let stationId: String
	let stationName: String
	let subwayList: String
	let stationList: String
	let isExpress: String // btrainSttus
	let date: String
	let message2: String // 열차 위치 메세지
	let message3: String // 열차 위치 역명
	let arrivalCode: String // arvlCd - 도착코드 (0:진입, 1:도착, 2:출발, 3:전역출발, 4:전역진입, 5:전역도착, 99:운행중)
	let isLastCar: String // lstcarAt - 막차여부 (1:막차, 0:아님)
    let barvlDt: String
	
	func subwayLine() -> String {
		switch self.subwayId {
		case "1001":
			return "1호선"
		case "1002":
			return "2호선"
		case "1003":
			return "3호선"
		case "1004":
			return "4호선"
		case "1005":
			return "5호선"
		case "1006":
			return "6호선"
		case "1007":
			return "7호선"
		case "1008":
			return "8호선"
		case "1009":
			return "9호선"
		case "1061":
			return "중앙선"
		case "1063":
			return "경의중앙선"
		case "1065":
			return "공항철도"
		case "1067":
			return "경춘선"
		case "1075":
			return "수인분당선"
		case "1077":
			return "신분당선"
		case "1092":
			return "우이신설선"
		case "1093":
			return "서해선"
		case "1081":
			return "경강선"
		case "1032":
			return "GTX-A"
		default:
			return ""
		}
	}
}

// MARK: - 지하철역 정보 검색(역명) Entity
struct StationEntity: Hashable, Identifiable {
	let id = UUID()
    let stationId: String
    let stationName: String
    let lineNumber: String
    let foreignerCode: String
	
	func lineName() -> String {
		lineNumber.replacingOccurrences(of: "0", with: "")
	}
}
