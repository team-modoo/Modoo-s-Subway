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
    let cardStore: SubwayCardStore

    init(subWayRepository: SubwayRepository = SubwayRepository()) {
        self.subWayRepository = subWayRepository
        self.subwayUseCase = SubwayUseCase(repository: subWayRepository)
        self.cardStore = SubwayCardStore(subwayUseCase: self.subwayUseCase)
    }
    
    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(subwayUseCase: subwayUseCase)
    }
    
    func makeSelectedStationViewModel() -> SelectedStationViewModel {
        return SelectedStationViewModel(subwayUseCase: subwayUseCase)
    }
}
