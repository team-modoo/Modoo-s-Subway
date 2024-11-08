//
//  HomeView.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/07/20.
//

import SwiftUI
import SwiftData

struct HomeView: View {
	// TODO: - DI Container 적용 필요함
	@StateObject var vm: SearchViewModel = SearchViewModel(subwayUseCase: SubwayUseCase(repository: SubwayRepository()))
	
	@State private var viewType: ViewType = .Star
	@State private var textFieldString: String = ""
	@State private var expressActiveState: Bool = false
	@State private var isSearchViewHidden: Bool = true
	
	var body: some View {
		NavigationStack {
			VStack {
				// MARK: - 헤더
				HStack {
					Image(.logo)
					
					Spacer()
					
					Button(action: {
						changeViewType(.Folder)
					}, label: {
						viewType == .Folder ? Image(.iconBookmarkGreen) : Image(.iconBookmark)
					})
					
					Button(action: {
						changeViewType(.Star)
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
                            .foregroundStyle(Color._5_C_5_C_5_C)
					}
                    .foregroundStyle(.black)
					.onSubmit {
						handleSearch()
					}
					.toolbar {
						ToolbarItemGroup(placement: .keyboard) {
							Spacer()
							
							Button(action: {
								hideKeyboard()
								
								if textFieldString.isEmpty {
									isSearchViewHidden = true
									vm.stations = []
								}
							}) {
								Image(systemName: "keyboard.chevron.compact.down")
									.foregroundColor(.blue)
							}
						}
					}
					.autocorrectionDisabled(true)
					.textInputAutocapitalization(.never)
					
					Button(action: {
						handleSearch()
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
					case .Folder:
						FolderView()
					case .Star:
						StarView()
					}
					
					if !isSearchViewHidden {
						SearchView(vm: vm)
					}
				}
				
				Spacer()
			}
			.padding(20)
		}
	}
	
	// MARK: - 폴더 or 즐겨찾기
	private func changeViewType(_ type: ViewType) {
		viewType = type
		isSearchViewHidden = true
		vm.stations = []
		textFieldString = ""
	}
	
	private func hideKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
	
	private func handleSearch() {
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

#Preview {
	HomeView()
}
