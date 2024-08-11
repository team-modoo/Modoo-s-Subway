//
//  FetchRealtimeViewModel.swift
//  modoosSubway
//
//  Created by 임재현 on 8/11/24.
//

import Combine
import Foundation

class FetchRealtimeViewModel: ObservableObject {
    private let fetchRealtimePositionsUseCase: FetchRealtimePositionUseCase
    @Published var positions: [SubwayDTO] = []
    @Published var apiData: ApiResponseData?
    @Published var error: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(fetchRealtimePositionsUseCase: FetchRealtimePositionUseCase) {
        self.fetchRealtimePositionsUseCase = fetchRealtimePositionsUseCase
    }
    
    func fetchPositions(for line:String,startIndex:Int,endIndex:Int) {
        guard let apikey = Configuration.shared.apiKey else {
            self.error = "API Key값이 유효하지 않습니다."
            return
        }
        
        let request = SubwayRequestDTO(key: apikey,
                                       type: "json",
                                       service: "realtimePosition",
                                       subwayNm: line,
                                       startIndex: startIndex,
                                       endIndex: endIndex)
        
        fetchRealtimePositionsUseCase.execute(request: request)
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { [weak self] completion in
                        switch completion {
                        case .failure(let error):
                            switch error {
                            case .invalidURL:
                                self?.error = "잘못된 URL입니다."
                            case .noData:
                                self?.error = "데이터를 받을 수 없습니다."
                            case .decodingError:
                                self?.error = "데이터 디코딩에 실패했습니다."
                            case .serverError(let statusCode):
                                self?.error = "서버 오류: \(statusCode)"
                            case .customError(_, let message):
                                self?.error = message
                            case .unknownError:
                                self?.error = "알 수 없는 오류가 발생했습니다."
                            }
                        case .finished:
                            break
                        }
                    }, receiveValue: { [weak self] responseDTO in
                        self?.positions = responseDTO.realtimePositionList
                        self?.apiData = responseDTO.errorMessage
                    })
                    .store(in: &cancellables)

    }
    
}
