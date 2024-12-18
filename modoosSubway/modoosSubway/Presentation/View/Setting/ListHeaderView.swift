//
//  ListHeaderView.swift
//  modoosSubway
//
//  Created by 김지현 on 12/15/24.
//

import SwiftUI

struct ListHeaderView: View {
	var iconImage: String = ""
	var titleLabel: String = ""
	
	init(iconImage: String, titleLabel: String) {
		self.iconImage = iconImage
		self.titleLabel = titleLabel
	}
	
	var body: some View {
		HStack {
			
			Image(iconImage)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 18,height: 18)
			
			Text("\(titleLabel)")
				.font(.pretendard(size: 18, family: .semiBold))
				.foregroundStyle(.black)
			
		}
		
	}
}

#Preview {
	ListHeaderView(iconImage:"icon-alarm", titleLabel: "알림")
}
