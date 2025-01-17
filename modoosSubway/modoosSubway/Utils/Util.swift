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
		var newMsg = ""
		
		if let _ = message.range(of: #"^\d+"#, options: .regularExpression) {
			if let range = message.range(of: "후") {
				newMsg = String(message[..<range.upperBound])
			}
		} else {
			// 괄호와 그 안의 내용 제거
			newMsg = message.replacingOccurrences(
				of: "[\\[\\]()]",
				with: "",
				options: .regularExpression
			)
			
			if newMsg.contains("번째 전역") {
				if let range = newMsg.range(of: "전역") {
					newMsg = String(newMsg[..<range.upperBound])
				}
			}
		}
		
		return newMsg
	}
	
	// MARK: - 열차 위치
	static func formatArrivalLocation(message2: String, message3: String, stations: [String]) -> Float {
		if message2.contains("전역 출발") {
			return 3.5
		} else if message2.contains("전역 도착") {
			return 3
		} else if message2.contains("도착") {
			return 4
		} else {
			return Float(stations.firstIndex { message3.contains($0) } ?? 5)
		}
	}
	
	// MARK: - 메세지가 몇분 후 인지 체크
	static func isArrivalTimeFormat(_ message: String) -> Bool {
		return message.range(of: #"^\d+분"#, options: .regularExpression) != nil
	}
	
	// MARK: - modify trainLineName ~행
	static func formatTrainLineName(_ trainLineName: String) -> String {
		let names = trainLineName.split(separator: " - ")
        if let firstPart = names.first {
            if firstPart.hasSuffix("행") {
                return String(firstPart)
            }
                return String(firstPart) + "행"
           }
           return ""
	}
	
	// MARK: - modify trainLineName ~방변
	static func getTrainDirection(_ trainLineName: String) -> String {
		let names = trainLineName.split(separator: " - ")
		if let lastPart = names.last {
			if lastPart.hasSuffix("방면") {
				return String(lastPart).replacingOccurrences(of: "방면", with: " 방향")
			}
			return String(lastPart) + " 방향"
		}
		return ""
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
