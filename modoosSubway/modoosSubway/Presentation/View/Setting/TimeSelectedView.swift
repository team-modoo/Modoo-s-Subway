//
//  TimeSelectedView.swift
//  modoosSubway
//
//  Created by 김지현 on 12/15/24.
//

import SwiftUI

struct TimeSelectedView: View {
	@Binding var selectedDate: Date
	let selectionType: TimeSelectionType
	@Environment(\.dismiss) private var dismiss
	
	var body: some View {
		VStack {
			HStack {
				Text("알림 설정하기")
					.font(.pretendard(size: 20, family: .bold))
					.foregroundStyle(.black)
				Spacer()
			}
			.padding(.horizontal, 20)
			.padding(.top, 30)
			
			HStack {
				Image("_icon_clock")
					.resizable()
					.frame(width: 18,height: 18)
				
				Text("시간 설정하기")
					.font(.pretendard(size: 16, family: .medium))
					.foregroundStyle(.black)
				
				Spacer()
				
			}
			.padding(.horizontal, 20)
			.padding(.top, 10)
			
			VStack {
				DatePicker("", selection: $selectedDate,
						   displayedComponents: [.hourAndMinute])
				.datePickerStyle(.wheel)
				.labelsHidden()
				.frame(width: 390)
				.frame(maxHeight: 250, alignment: .center)
				.clipped()
				.accentColor(.green)
				.padding(.horizontal, 16)
				
			}
			
			Button {
				print("설정하기")
				let timeInterval = selectedDate.timeIntervalSince1970
				let key = selectionType == .start ? "startTime" : "endTime"
				UserDefaults.standard.set(timeInterval, forKey: key)
				UserDefaults.standard.synchronize()
				
					// State 업데이트
				withAnimation {
					selectedDate = selectedDate
				}
				
				dismiss()
			} label: {
				Text("설정하기")
					.font(.pretendard(size: 16, family: .medium))
					.foregroundStyle(.white)
					.foregroundStyle(.white)
					.frame(width: 350, height: 56)
					.background(.theme)
					.cornerRadius(10)
			}
		}
	}
}
