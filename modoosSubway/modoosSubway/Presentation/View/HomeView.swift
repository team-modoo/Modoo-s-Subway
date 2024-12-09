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
    private let container: DIContainer
    @StateObject var homeViewModel: HomeViewModel
	@StateObject var searchViewModel: SearchViewModel

	@State private var viewType: ViewType = .Star
	@State private var textFieldString: String = ""
	@State private var expressActiveState: Bool = false
	@State private var isSearchViewHidden: Bool = true
    
    @State private var viewType2: FolderType = .Card
    @State private var sortedType: FolderSortedType = .name
    
    init(container: DIContainer) {
        self.container = container
        _homeViewModel = StateObject(wrappedValue: container.makeHomeViewModel())
        _searchViewModel = StateObject(wrappedValue: container.makeSearchViewModel())
    }
	
	var body: some View {
		NavigationStack {
			VStack {
				// MARK: - 헤더
				HStack {
					Image(.logo)
					
					Spacer()
					
					Button(action: {
                        homeViewModel.changeViewType(.Star)
					}, label: {
                        homeViewModel.selectedTab == .Star ? Image(.iconStarYellowBig) : Image(.iconStar)
					})
                   .padding(.trailing, 10)
					
					Button(action: {
                        homeViewModel.changeViewType(.Folder)
					}, label: {
                        homeViewModel.selectedTab == .Folder ? Image("icon_greenFolder") : Image("icon_folder")
					})
                    .padding(.trailing, 10)
					NavigationLink(destination: {
						SettingView()
					}, label: {
						Image(.iconSettings)
					})
				}
				.padding(.bottom, 20)
				
				// MARK: - 서치바
				HStack {
					TextField(text: $textFieldString) {
						Text("지하철 역명을 검색해 주세요")
							.font(.pretendard(size: 14, family: .regular))
                            .foregroundStyle(Color._5_C_5_C_5_C)
					}
                    .padding(.leading, 20)
                    .foregroundStyle(.black)

					.submitLabel(.search)
					.onSubmit {
						handleSearch()
					}
					.onAppear {
						UITextField.appearance().clearButtonMode = .whileEditing
					}
					.toolbar {
						ToolbarItem(placement: .keyboard) {
							HStack {
								Spacer()
								
								Button(action: {
									hideKeyboard()
									
									if textFieldString.isEmpty {
										isSearchViewHidden = true
										searchViewModel.stations = []
									}
								}) {
									Image(systemName: "keyboard.chevron.compact.down")
										.foregroundColor(.blue)
								}
							}
						}
					}
					.autocorrectionDisabled()
					.textInputAutocapitalization(.never)
					
					Button(action: {
						handleSearch()
					}, label: {
						Image(.iconSearch)
                            .resizable()
                            .frame(width: 24,height: 24)
					})
                    .padding(.trailing, 16)
				}
                .frame(height: 56)
				.background(Color("F5F5F5"))
				.clipShape(RoundedRectangle(cornerRadius: 10))
			
				// MARK: - 컨텐츠
				ZStack(alignment: .top) {
                    switch homeViewModel.selectedTab {
					case .Folder:
						FolderView()
					case .Star:
						StarView()
					}
					
                    if !homeViewModel.isSearchViewHidden {
                        SearchView(container: container, vm: searchViewModel)
					}
				}
				
				Spacer()
			}
			.padding(20)
		}
        .environmentObject(homeViewModel)
	}
	
	// MARK: - 폴더 or 즐겨찾기

	private func hideKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
	
	private func handleSearch() {
		hideKeyboard()
        homeViewModel.handleSearch(textFieldString, searchViewModel: searchViewModel)
	}
}

