//
//  HomeView.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/07/20.
//

import SwiftUI
import SwiftData

struct HomeView: View {
	@State private var viewType: ViewType = .star
	@State private var str: String = ""
	
	var body: some View {
		NavigationView {
			VStack {
					// MARK: - 헤더
				HStack {
					Image(.logo)
					
					Spacer()
					
					Button(action: {
						viewType = .bookmark
					}, label: {
						viewType == .bookmark ? Image(.iconBookmarkGreen) : Image(.iconBookmark)
					})
					
					Button(action: {
						viewType = .star
					}, label: {
						viewType == .star ? Image(.iconStarGreen) : Image(.iconStar)
					})
					
					NavigationLink(destination: {
						SettingView()
					}, label: {
						Image(.iconSettings)
					})
				}
				.padding(.bottom, 20)
				
					// MARK: - 서치바
				HStack {
					Button(action: {
						
					}, label: {
						Image(.expressInactive)
					})
					
					TextField(text: $str) {
						Text("지하철 역명을 검색해 주세요")
					}
					
					Button(action: {
						
					}, label: {
						Image(.iconSearch)
					})
				}
				.padding(.horizontal, 16)
				.padding(.vertical, 12)
				.background(Color("F5F5F5"))
				.clipShape(RoundedRectangle(cornerRadius: 10))
				
					// MARK: - 리스트뷰
				switch viewType {
				case .bookmark:
					BookMarkView()
				case .star:
					StarView()
				}
				
				Spacer()
			}
			.padding(20)
		}
	}
}

#Preview {
	HomeView()
}
