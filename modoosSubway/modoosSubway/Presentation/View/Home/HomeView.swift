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
    @StateObject var vm: HomeViewModel
	@State private var textFieldString: String = ""
	@State private var expressActiveState: Bool = false
    
    init(container: DIContainer) {
        self.container = container
        _vm = StateObject(wrappedValue: container.makeHomeViewModel())
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
							vm.changeViewType(.Star)
						}, label: {
							vm.selectedTab == .Star ? Image(.gnbStarYellow) : Image(.gnbStar)
						})
						.padding(.trailing, 8)
						
						Button(action: {
							vm.changeViewType(.Folder)
						}, label: {
							vm.selectedTab == .Folder ? Image(.gnbFolderGreen) : Image(.gnbFolder)
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
						TextField(text: $vm.searchText) {
							Text("지하철 역명을 검색해 주세요")
								.font(.pretendard(size: 14, family: .regular))
								.foregroundStyle(Color._5_C_5_C_5_C)
						}
						.padding(.leading, 20)
						.foregroundStyle(.black)
						.submitLabel(.search)
						.onSubmit {
							handleSubmit()
						}
						.onAppear {
							UITextField.appearance().clearButtonMode = .whileEditing
						}
						.onChange(of: vm.searchText) {
							vm.handleSearch()
						}
						.toolbar {
							ToolbarItem(placement: .keyboard) {
								HStack {
									Spacer()
									
									Button(action: {
										handleSubmit()
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
							handleSubmit()
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
					switch vm.selectedTab {
					case .Folder:
						FolderView()
							.padding(.top, 20)
							.padding(.horizontal, 20)
					case .Star:
						StarView(cardStore: container.cardStore)
							.padding(.top, 20)
							.padding(.horizontal, 20)
					}
					
					if !vm.isSearchViewHidden {
						SearchView(container: container, vm: vm)
					}
				}
				
				Spacer()
			}
		}
        .environmentObject(vm)
	}

	private func hideKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
	
	private func handleSubmit() {
		hideKeyboard()
		
		if textFieldString.isEmpty {
			vm.isSearchViewHidden = true
			vm.searchStations = []
		}
	}
}

