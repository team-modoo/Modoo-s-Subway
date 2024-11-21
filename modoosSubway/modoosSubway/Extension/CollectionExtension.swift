//
//  CollectionExtension.swift
//  modoosSubway
//
//  Created by 김지현 on 11/17/24.
//

import Foundation

extension Collection {
	subscript (safe index: Index) -> Element? {
		return indices.contains(index) ? self[index] : nil
	}
	
	subscript (safe range: ClosedRange<Index>) -> SubSequence? {
		guard range.lowerBound >= startIndex,
			  range.upperBound <= endIndex
		else { return nil }
		
		return self[range]
	}
}
