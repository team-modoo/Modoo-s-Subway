//
//  SelectedStationViewModel.swift
//  modoosSubway
//
//  Created by 김지현 on 8/30/24.
//

import Foundation

class SelectedStationViewModel: ObservableObject {
    private let subwayUseCase: SubwayUseCaseProtocol
    
    @Published var station: StaionEntity?
    
    init(subwayUseCase: SubwayUseCaseProtocol) {
        self.subwayUseCase = subwayUseCase
    }
}
