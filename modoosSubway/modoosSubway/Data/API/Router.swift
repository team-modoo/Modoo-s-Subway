//
//  Router.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/08/03.
//

import Alamofire

public protocol Router {
	var baseURL: String { get }
	var path: String { get }
	var method: HTTPMethod { get }
	var headers: [String: String]? { get }
	var parameters: [String: Any]? { get }
	var encoding: ParameterEncoding? { get }
}
