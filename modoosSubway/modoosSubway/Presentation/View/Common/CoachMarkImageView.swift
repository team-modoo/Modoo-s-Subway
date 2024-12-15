//
//  CoachMarkImageView.swift
//  modoosSubway
//
//  Created by 김지현 on 12/15/24.
//

import SwiftUI

//struct CoachMarkImageView: View {
//	var pageNumber: Int = 1
//	var lastPageNumber: Int = 6
//	
//	var body: some View {
//		VStack {
//			Image("coach\(pageNumber)")
//			
//			ZStack(alignment: .top) {
//				if pageNumber == lastPageNumber {
//					Button(action: {
//						// 코치마크뷰가 없어지고, HomeView로 화면 전환
//					}, label: {
//						Image(.xMark)
//					})
//				} else {
//					Button(action: {
//						// pageNumber가 1 증가하고, 새로운 Image로 리로드
//					}, label: {
//						Text("다음")
//							.font(.pretendard(size: 20, family: .regular))
//							.foregroundColor(.white)
//							.padding(.horizontal, 24)
//							.padding(.vertical, 12)
//							.background(Color.clear)
//							.border(.white, width: 1)
//							.cornerRadius(20)
//					})
//				}
//			}
//		}
//	}
//}

struct CoachMarkImageView: View {
	@State private var pageNumber: Int = 1
	let lastPageNumber: Int = 6
	@AppStorage("hasLaunchedBefore") private var hasLaunchedBefore = false
	@AppStorage("hasShownCoachMark") private var hasShownCoachMark = false
	
	var body: some View {
		ZStack(alignment: .bottom) {
			Image("coach\(pageNumber)")
				.resizable()
				.aspectRatio(contentMode: .fill)
				.transition(.slide)
				.animation(.easeInOut, value: pageNumber)
			
			// MARK: - 페이지 인디케이터
			HStack {
				ForEach(1...lastPageNumber, id: \.self) { page in
					Circle()
						.fill(page == pageNumber ? Color.white : Color.white.opacity(0.5))
						.frame(width: 10, height: 10)
				}
			}
			.padding(.bottom, 40)
			
			// MARK: - 버튼
			HStack {
				Spacer()
				
				if pageNumber == lastPageNumber {
					Button(action: {
						// MARK: - 코치마크 끝, 홈으로 이동
						hasLaunchedBefore = true
						hasShownCoachMark = true
					}) {
						Text("시작하기")
							.font(.pretendard(size: 20, family: .regular))
							.foregroundColor(.white)
							.padding(.horizontal, 24)
							.padding(.vertical, 12)
							.background(Color.clear)
							.overlay(
								RoundedRectangle(cornerRadius: 20)
									.stroke(Color.white, lineWidth: 1)
							)
					}
				} else {
					Button(action: {
						// MARK: - 다음 페이지로 이동
						withAnimation {
							pageNumber += 1
						}
					}) {
						Text("다음")
							.font(.pretendard(size: 20, family: .regular))
							.foregroundColor(.white)
							.padding(.horizontal, 24)
							.padding(.vertical, 12)
							.background(Color.clear)
							.overlay(
								RoundedRectangle(cornerRadius: 20)
									.stroke(Color.white, lineWidth: 1)
							)
					}
				}
				
				Spacer()
			}
			.padding(.bottom, 80)
		}
		.background(Color.black)
		.edgesIgnoringSafeArea(.all)
	}
}

struct CoachMarkImageView_Previews: PreviewProvider {
	static var previews: some View {
		CoachMarkImageView()
	}
}
