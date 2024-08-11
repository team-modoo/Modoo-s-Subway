//
//  SettingView.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/07/21.
//

import SwiftUI
import SwiftData

struct SettingView: View {
	@Environment(\.dismiss) private var dismiss
	
	var body: some View {
		NavigationView {
			VStack {
				HStack {
					Button(action: {
						dismiss()
					}) {
						Image(.back)
						Text("설정")
							.padding(.leading, -10)
							.tint(._333333)
					}
					
					Spacer()
				}
				.padding(.horizontal, 20)
				.padding(.top, 22)
				
				Spacer()
			}
		}
		.toolbar(.hidden, for: .navigationBar)
	}
}

#Preview {
	SettingView()
}
