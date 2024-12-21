//
//  ClearButton.swift
//  modoosSubway
//
//  Created by 김지현 on 12/18/24.
//

import SwiftUI

struct ClearButton: ViewModifier {
	@Binding var text: String
	
	func body(content: Content) -> some View {
		HStack {
			content
			if !text.isEmpty {
				Button {
					text = ""
				} label: {
					Image(systemName: "multiply.circle.fill")
						.foregroundColor(.BFBFBF)
				}
				.padding(.trailing, 16)
			}
		}
	}
}

extension View {
	func clearButton(text: Binding<String>) -> some View {
		modifier(ClearButton(text: text))
	}
}
