//
//  DIContainer.swift
//  modoosSubway
//
//  Created by 임재현 on 12/9/24.
//

import SwiftUI

class DIContainer {
    let subWayRepository: SubwayRepository
    let subwayUseCase: SubwayUseCaseProtocol
    
    init(subWayRepository: SubwayRepository = SubwayRepository()) {
        self.subWayRepository = subWayRepository
        self.subwayUseCase = SubwayUseCase(repository: subWayRepository)
    }
    
    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel()
    }
    
    func makeSearchViewModel() -> SearchViewModel {
        return SearchViewModel(subwayUseCase: subwayUseCase)
    }
    
    func makeSelectedStationViewModel() -> SelectedStationViewModel {
        return SelectedStationViewModel(subwayUseCase: subwayUseCase)
    }
}
