//
//  HomeView.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/07/20.
//

import SwiftUI
import SwiftData

struct HomeView: View {
	@StateObject var vm: SearchViewModel = SearchViewModel(subwayUseCase: SubwayUseCase(repository: SubwayRepository()))
	
	@State private var viewType: ViewType = .Star
	@State private var textFieldString: String = ""
	@State private var expressActiveState: Bool = false
	@State private var isSearchViewHidden: Bool = true
	
	var body: some View {
		NavigationView {
			VStack {
				// MARK: - 헤더
				HStack {
					Image(.logo)
					
					Spacer()
					
					Button(action: {
						viewType = .Bookmark
					}, label: {
						viewType == .Bookmark ? Image(.iconBookmarkGreen) : Image(.iconBookmark)
					})
					
					Button(action: {
						viewType = .Star
					}, label: {
						viewType == .Star ? Image(.iconStarYellowBig) : Image(.iconStar)
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
					Toggle(isOn: $expressActiveState, label: {
						expressActiveState ? Image(.expressActive) : Image(.expressInactive)
					})
					.toggleStyle(.button)
					
					TextField(text: $textFieldString) {
						Text("지하철 역명을 검색해 주세요")
							.font(.pretendard(size: 14, family: .regular))
					}
					.onSubmit {
						if !textFieldString.isEmpty {
							isSearchViewHidden = false
							vm.getSearchSubwayStations(for: textFieldString, startIndex: 0, endIndex: 5)
						} else {
							isSearchViewHidden = true
							vm.stations = []
						}
					}
					
					Button(action: {
						if !textFieldString.isEmpty {
							isSearchViewHidden = false
							vm.getSearchSubwayStations(for: textFieldString, startIndex: 0, endIndex: 5)
						} else {
							isSearchViewHidden = true
							vm.stations = []
						}
					}, label: {
						Image(.iconSearch)
					})
				}
				.padding(.trailing, 16)
				.padding(.leading, 10)
				.padding(.vertical, 4)
				.background(Color("F5F5F5"))
				.clipShape(RoundedRectangle(cornerRadius: 10))
			
				// MARK: - 컨텐츠
				ZStack(alignment: .top) {
					switch viewType {
					case .Bookmark:
						BookMarkView()
					case .Star:
						StarView()
					}
					
					if !isSearchViewHidden {
						SearchView(vm: vm, searchStationName: textFieldString)
					}
				}
				
				Spacer()
			}
			.padding(20)
		}
		.onTapGesture {
			hideKeyboard()
			
			if !textFieldString.isEmpty {
				isSearchViewHidden = false
				vm.getSearchSubwayStations(for: textFieldString, startIndex: 0, endIndex: 5)
			} else {
				isSearchViewHidden = true
				vm.stations = []
			}
		}
	}
	
	private func hideKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}

#Preview {
	HomeView()
}
