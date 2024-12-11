//
//  SubwayCardStore.swift
//  modoosSubway
//
//  Created by 임재현 on 12/10/24.
//

import SwiftUI
import Combine

class SubwayCardStore: ObservableObject {
    @Published var cards: [UUID:CardViewEntity] = [:]
    private let subwayUseCase: SubwayUseCaseProtocol
    private var cancellables =  Set<AnyCancellable>()
    
    init(subwayUseCase: SubwayUseCaseProtocol) {
        self.subwayUseCase = subwayUseCase
    }
    
    func refreshAllCards() {
        print("🔄 새로고침 시작")
        print("현재 저장된 카드 수: \(cards.count)")
        let uniqueStations = Set(cards.values.map {$0.stationName})
        let existingCards = cards
        print("업데이트할 역 목록: \(uniqueStations)")
        
        uniqueStations.forEach { stationName in
            let request = RealtimeStationArrivalRequestDTO(
                key: Util.getApiKey(),
                startIndex: 1,
                endIndex: 100,
                subwayName: stationName)
            
        subwayUseCase.executeRealtimeStationArrival(request: request)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] result in
                    switch result {
                    case .success(let arrivals):
                        self?.updateCards(for: stationName, with: arrivals, existingCards: existingCards)
                    case .error(let error):
                        print("Error refreshing station \(stationName): \(error)")
                    default:
                        break
                    }
                }
                .store(in: &cancellables)
        }
        
    }

    private func updateCards(for stationName: String, with arrivals: [ArrivalEntity], existingCards: [UUID: CardViewEntity]) {
       print("\n🚉 \(stationName) 업데이트")
       print("받은 도착 정보 수: \(arrivals.count)")
       
       // existingCards에서 해당 역의 카드들 찾기
       let stationCards = existingCards.values.filter { $0.stationName == stationName }
       print("업데이트할 카드 수: \(stationCards.count)")
       
       // 기존 순서를 유지하면서 카드 업데이트
       for card in stationCards {
           print("\n카드 정보 - 역: \(card.stationName), 호선: \(card.lineNumber), 방향: \(card.upDownLine)")
           let oldMessage = card.arrivalMessage
           
           let matchingArrivals = arrivals.filter { arrival in
               // 호선 정규화 및 비교
               let normalizedArrivalLine = arrival.subwayLine().replacingOccurrences(of: "호선", with: "")
               let normalizedCardLine = card.lineNumber.replacingOccurrences(of: "호선", with: "")
                   .replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
               
               let lineMatches = normalizedArrivalLine == normalizedCardLine
               let directionMatches = (arrival.upDownLine == "상행" && card.upDownLine == "상행선") ||
                                   (arrival.upDownLine == "하행" && card.upDownLine == "하행선") ||
                                   (arrival.upDownLine == "내선" && card.upDownLine == "내선") ||
                                   (arrival.upDownLine == "외선" && card.upDownLine == "외선")
               
               print("도착정보 검사 - 정규화된 호선: \(normalizedArrivalLine) vs \(normalizedCardLine)")
               print("도착정보 검사 - 호선일치: \(lineMatches), 방향일치: \(directionMatches)")
               print("arrival 방향: \(arrival.upDownLine), card 방향: \(card.upDownLine)")
               
               return lineMatches && directionMatches
           }
           
           if let firstArrival = matchingArrivals.first {
               print("[\(card.stationName)] 도착 정보 업데이트:")
               print("이전 메시지: \(oldMessage)")
               
               // 카드 정보 업데이트하되 원본 ID 유지
               var updatedCard = card
               updatedCard.arrivalMessage = firstArrival.message2
               updatedCard.isExpress = firstArrival.isExpress
               updatedCard.arrivals = matchingArrivals.map {
                   Arrival(
                       arrivalCode: $0.arrivalCode,
                       station: $0.stationName,
                       trainLineName: $0.trainLineName,
                       barvlDt: $0.barvlDt
                   )
               }
               
               // 동일한 ID로 카드 업데이트
               cards[card.id] = updatedCard
               print("새로운 메시지: \(updatedCard.arrivalMessage)")
           } else {
               print("⚠️ 매칭되는 도착 정보가 없습니다")
           }
       }
    }
    func loadSavedCards(from stars: [Star]) {
          cards.removeAll()
          stars.forEach { star in
              cards[star.subwayCard.id] = star.subwayCard
          }
          print("Store에 로드된 카드 수: \(cards.count)")
      }
    
    
}
