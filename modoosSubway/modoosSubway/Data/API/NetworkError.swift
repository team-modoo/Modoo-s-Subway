//
//  NetworkError.swift
//  modoosSubway
//
//  Created by 임재현 on 8/11/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int) // HTTP 상태 코드와 함께 처리
    case customError(code: String, message: String) // 서버에서 반환된 오류 메시지 처리
    case unknownError
}
