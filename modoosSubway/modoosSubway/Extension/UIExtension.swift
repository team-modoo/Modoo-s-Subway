//
//  UIExtension.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/07/28.
//

import SwiftUI

// MARK: - 커스텀 폰트
extension Font {
	enum Family: String {
		case regular, medium, semiBold, bold
	}
	
	static func pretendard(size: CGFloat, family: Family) -> Font {
		return Font.custom("Pretendard-\(family)", size: size)
	}
}
