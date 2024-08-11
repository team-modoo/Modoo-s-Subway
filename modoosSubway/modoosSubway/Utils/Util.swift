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
}
