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
    @State private var showSheet = false
    @State private var showStartTimePicker = false
	@State private var showEndTimePicker = false
	@State private var showAlert = false
	
	// AppStorage로 시작, 끝 시간 저장
	@AppStorage("startTime") private var startTimeInterval: TimeInterval = Date().timeIntervalSince1970 {
		didSet {
			startTime = Date(timeIntervalSince1970: startTimeInterval)
		}
	}
	@AppStorage("endTime") private var endTimeInterval: TimeInterval = Date().timeIntervalSince1970 {
		didSet {
			endTime = Date(timeIntervalSince1970: endTimeInterval)
		}
	}
	
	// 저장된 TimeInterval을 Date로 변환하여 사용할 State 변수
	@State private var startTime: Date
	@State private var endTime: Date
    
    let section1: [SettingToggleType] = [.sound, .vibration, .notification, .manner]
    let section2 = ["1"]
    let section3: [InformationType] = [.version, .privacy, .terms]
    var isToggled = false
	
	private let timeFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "a h:mm"
		formatter.locale = Locale(identifier: "ko_KR")
		return formatter
	}()
	
	init() {
		let savedStartTime = UserDefaults.standard.double(forKey: "startTime")
		let savedEndTime = UserDefaults.standard.double(forKey: "endTime")
		_startTime = State(initialValue: Date(timeIntervalSince1970: savedStartTime))
		_endTime = State(initialValue: Date(timeIntervalSince1970: savedEndTime))
	}
	
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
				.background(.white)
				.padding(.horizontal, 20)
				.padding(.top, 22)
				
				VStack {
					List {
						Section {
							ForEach(section1,id: \.self) { index in
								SettingCell(isSection1: true, title: index.rawValue, toggleType: index, showAlert: $showAlert)
									.listRowBackground(Color.clear)
									.frame(height:30)
									.listRowSeparator(.hidden)
									.padding(.bottom, index == section1.last ? 3 : 20)
							}
							.listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
						} header: {
							ListHeaderView(iconImage: "icon-alarm", titleLabel: "알림 ")
								.background(.white)
								.listRowInsets(EdgeInsets(top: 30, leading: 20, bottom: 30, trailing: 20))
						} footer: {
							VStack {
								
								HStack {
									Text("설정한 시간 동안 알림 거부")
										.font(.pretendard(size: 14, family: .regular))
										.foregroundStyle(._5_C_5_C_5_C)
									Spacer()
								}
								.listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
								.background(.clear)
								
								HStack {
									Button {
										self.showStartTimePicker = true
									} label: {
										ZStack {
											RoundedRectangle(cornerRadius: 10)
												.foregroundStyle(.D_9_D_9_D_9)
												.opacity(0.12)
												.frame(width: 94, height: 34)
											
											Text(timeFormatter.string(from: startTime))
												.font(.pretendard(size: 17, family: .regular))
												.foregroundStyle(.black)
										}
									}
									.sheet(isPresented: $showStartTimePicker) {
										// sheet가 닫힐 때 유효성 검사
										validateTimeRange()
									} content: {
										TimeSelectedView(
											selectedDate: $startTime,
											selectionType: .start
										)
										.presentationDetents([.fraction(1/2)])
										.presentationDragIndicator(.visible)
										.presentationCornerRadius(30)
									}
									.buttonStyle(.borderless)
									
									Text("~")
										.font(.pretendard(size: 17, family: .bold))
									
									Button {
										self.showEndTimePicker = true
									} label: {
										ZStack {
											RoundedRectangle(cornerRadius: 10)
												.foregroundStyle(.D_9_D_9_D_9)
												.opacity(0.12)
												.frame(width: 94, height: 34)
											
											Text(timeFormatter.string(from: endTime))
												.font(.pretendard(size: 17, family: .regular))
												.foregroundStyle(.black)
										}
									}
									.buttonStyle(.borderless)
									.sheet(isPresented: $showEndTimePicker) {
										validateTimeRange()
									} content: {
										TimeSelectedView(
											selectedDate: $endTime,
											selectionType: .end
										)
										.presentationDetents([.fraction(1/2)])
										.presentationDragIndicator(.visible)
										.presentationCornerRadius(30)
									}
									
									Spacer()
									
								}
								.padding(.top,5)
							}
						}
						
						Section {
							ForEach(section2,id: \.self) { index in
								HStack {
									Rectangle()
										.foregroundStyle(.D_9_D_9_D_9)
										.frame(height:1)
								}
								.padding(.vertical, 20)
								.listRowBackground(Color.clear)
								.frame(height:1)
								.listRowSeparator(.hidden)
							}
						}
						
						Section {
							ForEach(section3, id: \.self) { index in
								SettingCell(isSection1: false, title: index.rawValue, destination: index.destination(), infoType: index, showAlert: $showAlert)
									.listRowBackground(Color.clear)
									.frame(height:30)
									.listRowSeparator(.hidden)
									.padding(.bottom, index == section3.last ? 3 : 20)
							}
							.listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
						} header: {
							ListHeaderView(iconImage: "icon-information", titleLabel: "정보 및 약관")
								.background(.white)
								.listRowInsets(EdgeInsets(top: 20, leading: 20, bottom: 30, trailing: 20))
						}
					}
					.listSectionSpacing(0)
					.listStyle(GroupedListStyle())
					.scrollContentBackground(.hidden)
					.background(Color.white)
				}
				.background(.clear)
				
				Spacer()
			}
			.background(.white)
		}
		.onAppear {
			// 뷰가 나타날 때마다 저장된 시간 다시 로드
			startTime = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "startTime"))
			endTime = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "endTime"))
		}
		.alert("", isPresented: $showAlert) {
			Button("확인", role: .cancel) {}
		} message: {
			Text("준비중인 기능입니다.")
		}
		// startDate가 변경될 때마다 AppStorage 업데이트
		.onChange(of: startTime) { _, newValue in
			startTimeInterval = newValue.timeIntervalSince1970
		}
		// endDate도 같은 방식으로
		.onChange(of: endTime) { _, newValue in
			endTimeInterval = newValue.timeIntervalSince1970
		}
		.onDisappear {
			UserDefaults.standard.synchronize()
		}
		.toolbar(.hidden, for: .navigationBar)
	}
	
	
	private func validateTimeRange() {
		if endTime < startTime {
			endTime = Calendar.current.date(byAdding: .hour, value: 1, to: startTime) ?? startTime
		}
	}
}
