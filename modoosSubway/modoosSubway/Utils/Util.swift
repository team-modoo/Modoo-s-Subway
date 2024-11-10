//
//  Util.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/07/21.
//

import Foundation

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
}
