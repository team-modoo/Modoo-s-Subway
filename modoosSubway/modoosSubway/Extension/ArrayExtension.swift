//
//  ArrayExtension.swift
//  modoosSubway
//
//  Created by 김지현 on 12/20/24.
//

import Foundation

extension Array where Element: Hashable {
	func removeDuplicates(by key: (Element) -> String) -> [Element] {
		var seenKeys: Set<String> = []
		return self.filter { element in
			let keyValue = key(element)
			if seenKeys.contains(keyValue) {
				return false
			} else {
				seenKeys.insert(keyValue)
				return true
			}
		}
	}
}
