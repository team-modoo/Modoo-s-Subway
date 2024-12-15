//
//  OnBoardingView.swift
//  modoosSubway
//
//  Created by 김지현 on 12/15/24.
//

import SwiftUI

struct OnBoardingView: View {
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
			}
		}
		.background(Color.black)
		.edgesIgnoringSafeArea(.all)
	}
}

struct OnBoardingView_Previews: PreviewProvider {
	static var previews: some View {
		OnBoardingView()
	}
}
