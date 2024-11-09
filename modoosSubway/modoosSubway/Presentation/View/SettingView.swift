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
    let section1: [SettingToggleType] = [.sound, .vibration, .notification]
    let section2: [InformationType] = [.version, .privacy, .terms, .appUsage]
    var isToggled = false
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
                                    .frame(height: 55)
                                    .listRowSeparator(.hidden)
                                    
                                    
                            }
                          
                            .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 16))
                          
                        } header: {
                            ListHeaderView(iconImage: "icon-alarm", titleLabel: "알림")
                        }
                        
                        Section {
                            ForEach(section2,id: \.self) { index in
                                             
                                SettingCell(isSection1: false, title: index.rawValue, destination: index.destinationView())
                                         }
                            
                            .frame(height: 55)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            
                          
                            .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 16))
                          
                        }
                        
                    header: {
                            ListHeaderView(iconImage: "icon-alarm", titleLabel: "정보 및 약관")
                        }

                    }
                   //   .frame( maxWidth: .infinity)
                     // .edgesIgnoringSafeArea(.all)
                    .listStyle(GroupedListStyle())
                    
                    .scrollContentBackground(.hidden)
                    .background(Color.white)
                }
                .background(.blue)
				
				Spacer()
			}
           .background(.white)
		}
        .task {
            print("")
        }
      //  .background(.red)
		.toolbar(.hidden, for: .navigationBar)
	}
       
}


//#Preview {
//	SettingView()
//}

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
                .aspectRatio(contentMode: .fill)
                .frame(width: 20,height: 20)
            
            Text("\(titleLabel)")
                .font(.pretendard(size: 20, family: .bold))
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
    private var destination: AnyView?
    
    init(isSection1: Bool, title: String, toggleType: SettingToggleType) {
        self.isSection1 = isSection1
        self.title = title
        self._toggleState = AppStorage(wrappedValue: false, "setting_toggle_\(toggleType.rawValue)")
        self.toggleType = toggleType
        self.destination = nil
    }

    init(isSection1: Bool, title: String, destination: AnyView) {
        self.isSection1 = isSection1
        self.title = title
        self._toggleState = AppStorage(wrappedValue: true, "dummy_key")
        self.destination = destination
    }
    
    var body: some View {
        if isSection1 {
            HStack {
                Text(title)
                    .font(.pretendard(size: 20, family: .regular))
                    .foregroundStyle(.black)
                Spacer()
                Toggle(isOn: $toggleState) {
                    // EmptyView()
                }
                
                .onChange(of: toggleState) { _ , newValue in
                    handleToggleChange(newValue)
                }
            }
        } else {
            // 두 번째 섹션 - 네비게이션 링크
            if let destination = destination {
                NavigationStack {
                    
                    NavigationLink(destination: destination) {
                        HStack {
                            Text(title)
                                .font(.pretendard(size: 20, family: .regular))
                                .foregroundStyle(.black)
                         // Spacer()
                         // Image("more 1")
                        }
                    }
                }
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
}

enum InformationType: String {
    case version = "버전 정보"
    case privacy = "개인정보처리방침"
    case terms = "이용 약관"
    case appUsage = "앱 사용법"
    
    func destinationView() -> AnyView {
        switch self {
        case .version:
            return AnyView(FolderView())
        case .privacy:
            return AnyView(FolderView())
        case .terms:
            return AnyView(FolderView())
        case .appUsage:
            return AnyView(FolderView())
        }
    }
    
}


