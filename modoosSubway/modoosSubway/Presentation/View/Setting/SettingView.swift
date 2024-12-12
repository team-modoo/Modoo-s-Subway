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
                                SettingCell(isSection1: true, title: index.rawValue, toggleType: index)
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
                            ForEach(section3,id: \.self) { index in
                                SettingCell(isSection1: false, title: index.rawValue, destination: index.destinationView(),infoType: index)
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
        .task {
            print("")
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

struct SettingCell: View {
    @State private var isOn = true
    @AppStorage private var toggleState: Bool
    private var isSection1: Bool
    private var title: String
    private var toggleType: SettingToggleType = .notification
    private var infoType: InformationType = .version
    private var destination: AnyView?
    
    init(isSection1: Bool, title: String, toggleType: SettingToggleType) {
        self.isSection1 = isSection1
        self.title = title
        self._toggleState = AppStorage(wrappedValue: false, "setting_toggle_\(toggleType.rawValue)")
        self.toggleType = toggleType
        self.destination = nil
    }

    init(isSection1: Bool, title: String, destination: AnyView,infoType:InformationType) {
        self.isSection1 = isSection1
        self.title = title
        self._toggleState = AppStorage(wrappedValue: true, "dummy_key")
        self.destination = destination
        self.infoType = infoType
    }
    
    var body: some View {
        if isSection1 {
            HStack {
                Text(title)
                    .font(.pretendard(size: 16, family: .medium))
                    .foregroundStyle(.black)
                Spacer()
                Toggle(isOn: $toggleState) {
                    // EmptyView()
                }
                
                .onChange(of: toggleState) { _ , newValue in
                    handleToggleChange(newValue)
                }
            }
            .frame(height: 30)
            .background(.white)
        } else {
            // 두 번째 섹션 - 네비게이션 링크
            if let destination = destination {
                HStack {
                    Text(title)
                        .font(.pretendard(size: 16, family: .medium))
                        .foregroundStyle(.black)
                    
                    Spacer()
                    if infoType.rawValue == "버전 정보" {
                        Text("v 1.0")
                            .font(.pretendard(size: 14, family: .semiBold))
                            .foregroundStyle(.BFBFBF)
                    } else {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.black)
                    }
                }
                .frame(height: 30)
                .background(.white)
                .background(
                    Group {
                        if infoType.rawValue != "버전 정보" {
                            NavigationLink("", destination: destination)
                                .opacity(0)
                        }
                    }
                )
            }
        }
    }

    private func handleToggleChange(_ newValue: Bool) {
        print("\(title) 토글 상태 변경: \(newValue)")
    }
}


enum SettingToggleType: String {
    case sound = "효과음"
    case vibration = "진동"
    case notification = "푸시 알림"
    case manner = "에티켓 시간 설정"
}

enum InformationType: String {
    case version = "버전 정보"
    case privacy = "개인정보처리방침"
    case terms = "이용 약관"
    //case appUsage = "앱 사용법"
    
    func destinationView() -> AnyView {
        switch self {
        case .version:
            return AnyView(FolderView())
        case .privacy:
            return AnyView(FolderView())
        case .terms:
            return AnyView(FolderView())
        }
    }
    
}

enum TimeSelectionType {
    case start
    case end
    
    var title: String {
        switch self {
        case .start: return "시작 시간"
        case .end: return "종료 시간"
        }
    }
}

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
