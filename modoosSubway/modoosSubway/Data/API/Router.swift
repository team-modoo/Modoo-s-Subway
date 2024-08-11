//
//  Router.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/08/03.
//

import Foundation

class Configuration {
    static let shared = Configuration()

    private init() { }

    private let configDict: NSDictionary? = {
        guard let path = Bundle.main.path(forResource: "secret", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) else {
            return nil
        }
        return dict
    }()

    var apiKey: String? {
        return configDict?["SEOUL_DATA_API_KEY"] as? String
    }

    var baseURL: String? {
        return configDict?["BASE_URL"] as? String
    }
}


