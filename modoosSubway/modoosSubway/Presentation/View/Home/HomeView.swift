//
//  HomeView.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/07/20.
//

import SwiftUI
import SwiftData

struct HomeView: View {
	
    private let container: DIContainer
    @StateObject var homeViewModel: HomeViewModel
	@StateObject var searchViewModel: SearchViewModel
	@State private var textFieldString: String = ""
	@State private var expressActiveState: Bool = false
    
    init(container: DIContainer) {
        self.container = container
        _homeViewModel = StateObject(wrappedValue: container.makeHomeViewModel())
        _searchViewModel = StateObject(wrappedValue: container.makeSearchViewModel())
    }
	
	var body: some View {
		NavigationStack {
			VStack {
				VStack {
					// MARK: - 헤더
					HStack {
						Image(.logo)
						
						Spacer()
						
						Button(action: {
							homeViewModel.changeViewType(.Star)
						}, label: {
							homeViewModel.selectedTab == .Star ? Image(.gnbStarYellow) : Image(.gnbStar)
						})
						.padding(.trailing, 8)
						
						Button(action: {
							homeViewModel.changeViewType(.Folder)
						}, label: {
							homeViewModel.selectedTab == .Folder ? Image(.gnbFolderGreen) : Image(.gnbFolder)
						})
						.padding(.trailing, 8)
						
						NavigationLink(destination: {
							SettingView()
						}, label: {
							Image(.gnbSettings)
						})
					}
					.padding(.bottom, 20)
					
					// MARK: - 서치바
					HStack {
						TextField(text: $homeViewModel.searchText) {
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
											homeViewModel.isSearchViewHidden = true
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
					.frame(height: 50)
					.background(Color(.F_5_F_5_F_5))
					.clipShape(RoundedRectangle(cornerRadius: 10))
				}
				.padding(.top, 20)
				.padding(.horizontal, 20)
				
				// MARK: - 컨텐츠
				ZStack(alignment: .top) {
					switch homeViewModel.selectedTab {
					case .Folder:
						FolderView()
							.padding(.top, 20)
							.padding(.horizontal, 20)
					case .Star:
						StarView()
							.padding(.top, 20)
							.padding(.horizontal, 20)
					}
					
					if !homeViewModel.isSearchViewHidden {
						SearchView(container: container, vm: searchViewModel)
					}
				}
				
				Spacer()
			}
		}
        .environmentObject(homeViewModel)
	}

	private func hideKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
	
	private func handleSearch() {
		hideKeyboard()
        homeViewModel.handleSearch(searchViewModel: searchViewModel)
        print("\(textFieldString)")
	}
}

