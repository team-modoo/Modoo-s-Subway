//
//  EnumType.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/08/03.
//

import Foundation

// MARK: - 홈화면의 뷰 타입
enum ViewType {
	case Folder
	case Star
}
// MARK: - 홈화면의 폴더 타입
enum FolderType {
    case Card
    case List
}

enum FolderSortedType {
    case latest // 최신순
    case name // 이름순
}

// MARK: - 뷰컨과 뷰모델 사이에 넘겨줄 데이터 타입
enum ExecutionType<T> {
	case trigger // 넘겨줄 데이터가 없을때
	case success(_ data: T)
	case error(_ error: NetworkError)
}
