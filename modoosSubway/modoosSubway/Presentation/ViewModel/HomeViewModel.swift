//
//  HomeViewModel.swift
//  modoosSubway
//
//  Created by 임재현 on 12/9/24.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var selectedTab: ViewType = .Star
    @Published var isSearchViewHidden: Bool = true
    @Published var searchStations: [StationEntity] = []
    @Published var searchText: String = ""
    
    func changeViewType(_ type: ViewType) {
        selectedTab = type
        isSearchViewHidden = true
        searchStations = []
        searchText = ""
    }
    
	func handleSearch(searchViewModel: SearchViewModel) {
		if !searchText.isEmpty {
			isSearchViewHidden = false
			searchViewModel.getSearchSubwayStations(
				for: searchText,
				service: "SearchInfoBySubwayNameService",
				startIndex: 1,
				endIndex: 5
			)
		} else {
			isSearchViewHidden = true
			searchViewModel.stations = []
		}
	}
}
