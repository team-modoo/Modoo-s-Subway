//
//  StarViewModel.swift
//  modoosSubway
//
//  Created by 김지현 on 2024/08/03.
//

import SwiftUI
import Combine
import SwiftData

class StarViewModel: ObservableObject {
    private var timer: Timer?
    private let subwayUseCase: SubwayUseCaseProtocol
	@Published var errorMessage: String?
	@Published var isError: Bool = false
//    private let modelContext: ModelContext
	@Published var cards: [CardViewEntity] = []
    private var cancellables = Set<AnyCancellable>()
	
    init(subwayUseCase: SubwayUseCaseProtocol) {
        self.subwayUseCase = subwayUseCase
    }
	
    func startRealTimeUpdates() {
        updateAllCards()
        
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [weak self] _ in
            self?.updateAllCards()
        })
    }
	
    func stopRealTimeUpdates() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateAllCards() {
        cards.forEach { card in
            subwayUseCase.executeRealtimeStationArrival(
                request: RealtimeStationArrivalRequestDTO(
                    key: Util.getApiKey(),
                    startIndex: 1,
                    endIndex: 100,
                    subwayName: card.stationName))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                    self.isError = true
                    }
            } receiveValue: { [weak self] result in
                self?.updateCard(for: card, with: result)
            }
            .store(in: &cancellables)

        }
    }
    private func updateCard(for card: CardViewEntity, with result: ExecutionType<[ArrivalEntity]>) {
           switch result {
           case .success(let data):
               print("업데이트 성공: \(card.stationName) \(card.upDownLine)")
               // 현재 카드와 같은 방향의 도착 정보만 필터링
               let arrivals = data.filter {
                   let upDownLine = UpDownLineType(rawValue: $0.upDownLine)
                   switch upDownLine {
                   case .Up where card.upDownLine == "상행선",
                        .Down where card.upDownLine == "하행선",
                        .In where card.upDownLine == "내선",
                        .Out where card.upDownLine == "외선":
                       return true
                   default:
                       return false
                   }
               }
               
               if let index = self.cards.firstIndex(where: { $0.id == card.id }) {
                   // 카드 정보 업데이트
                   let oldMessage = self.cards[index].arrivalMessage
                   self.cards[index].arrivalMessage = arrivals.first?.message2 ?? ""
                   print("도착 정보 변경: \(oldMessage) -> \(self.cards[index].arrivalMessage)")
                   self.cards[index].isExpress = arrivals.first?.isExpress ?? ""
                   self.cards[index].arrivals = arrivals.map {
                       Arrival(
                           arrivalCode: $0.arrivalCode,
                           station: $0.stationName,
                           trainLineName: $0.trainLineName,
                           barvlDt: $0.barvlDt
                       )
                   }
               }
               
           case .error(let error):
               // 에러 처리
               print("Error updating card: \(error)")
           default:
               break
           }
       }
    deinit {
        stopRealTimeUpdates()
    }
}
