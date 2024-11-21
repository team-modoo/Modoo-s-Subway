//
//  Util.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/07/21.
//

import SwiftUI

class Util {
	// MARK: - API Key
	static func getApiKey() -> String {
		guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
			  let dict = NSDictionary(contentsOfFile: path) else {
			return ""
		}
		let apiKey: String = dict["SEOUL_DATA_API_KEY"] as? String ?? ""
		
		return apiKey
	}
	
	// MARK: - 메세지 2 trim
	static func formatArrivalMessage(_ message: String) -> String {
		if let match = message.range(of: #"^\d+"#, options: .regularExpression) {
			let minutes = String(message[match])
			return "\(minutes)분"
		} else {
			// 괄호와 그 안의 내용 제거
			let newMsg = message.replacingOccurrences(
				of: "[\\[\\]()]",
				with: "",
				options: .regularExpression
			)
			
			return newMsg
		}
	}
	
	// MARK: - 메세지가 몇분 후 인지 체크
	static func isArrivalTimeFormat(_ message: String) -> Bool {
		return message.range(of: #"^\d+분"#, options: .regularExpression) != nil
	}
	
	// MARK: - modify trainLineName
	static func formatTrainLineName(_ trainLineName: String) -> String {
		let names = trainLineName.split(separator: " - ")
		return String(names.first ?? "")
	}
	
	// MARK: - 노선별 컬러
	static func getLineColor(_ lineNumber: String) -> Color {
		switch lineNumber {
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
		case "중앙선":
			return .lineMiddle
		case "신림선":
			return .lineShinlim
		case "우이신설선":
			return .lineWuyi
		case "경의중앙선":
			return .lineKyungyiMiddle
		case "서해선":
			return .lineSuhae
		case "경춘선":
			return .lineGyungchun
		case "경강선":
			return .lineGyunggang
		case "GTX-A":
			return .lineGtxa
		default:
			return .gray
		}
	}
}
