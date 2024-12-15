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
enum FolderType: String, Codable {
    case Card
    case List
}

enum FolderSortedType: String, Codable {
    case latest // 최신순
    case name // 이름순
    
    var sortDescriptor: SortDescriptor<Folder> {
        switch self {
        case .latest:
            return SortDescriptor(\Folder.timestamp,order: .reverse)
        case .name:
            return SortDescriptor(\Folder.title,order: .forward)
        }
    }
    
}

enum StarSortedType: String, Codable {
    case upLine // 상행선
    case downLine // 하행선
    case all
    
//    var sortDescriptor: SortDescriptor<Folder> {
//        switch self {
//        case .upLine:
//            return SortDescriptor(\Folder.timestamp,order: .reverse)
//        case .downLine:
//            return SortDescriptor(\Folder.title,order: .forward)
//        }
//    }
    
}




// MARK: - 지하철 upDownLine의 타입
enum UpDownLineType: String {
	case Up = "상행"
	case Down = "하행"
	case Out = "외선"
	case In = "내선"
}

// MARK: - 뷰컨과 뷰모델 사이에 넘겨줄 데이터 타입
enum ExecutionType<T> {
	case trigger // 넘겨줄 데이터가 없을때
	case success(_ data: T)
	case error(_ error: NetworkError)
}

enum SubwayDirection {
    case up     // 상행/외선
    case down   // 하행/내선
    case none   // 필터 미적용
    
    var displayText: String {
        switch self {
        case .up:
            return "상행선"
        case .down:
            return "하행선"
        case .none:
            return ""
        }
    }
    var directions: [String] {
        switch self {
        case .up:
            return ["상행선", "외선"]
        case .down:
            return ["하행선", "내선"]
        case .none:
            return []
        }
    }
}

// MARK: - 설정
enum SettingToggleType: String {
	case sound = "효과음"
	case vibration = "진동"
	case notification = "푸시 알림"
	case manner = "에티켓 시간 설정"
}

enum InformationType: String {
	case version = "버전 정보"
	case privacy = "개인정보처리방침"
	case terms = "이용 약관"
	
	func destination() -> String {
		switch self {
		case .version:
			return ""
		case .privacy:
			return "https://github.com/team-modoo/Modoo-s-Subway/blob/develop/policy/privacy-policy.md#privacy-policy"
		case .terms:
			return "https://github.com/team-modoo/Modoo-s-Subway/blob/develop/policy/terms-and-condition.md#terms--conditions"
		}
	}
}

enum TimeSelectionType {
	case start
	case end
	
	var title: String {
		switch self {
		case .start: return "시작 시간"
		case .end: return "종료 시간"
		}
	}
}
