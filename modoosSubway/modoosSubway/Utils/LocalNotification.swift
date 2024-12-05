//
//  LocalNotification.swift
//  modoosSubway
//
//  Created by 임재현 on 12/3/24.
//

import Foundation
import UserNotifications
import SwiftUI

struct Notification {
    var id: String
    var title: String
}

class LocalNotificationManager {
    var notifications = [Notification]()
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                completion(granted && error == nil)
            }
        }
    }
    
    func addNotification(title: String) -> Void {
        notifications.append(Notification(id: UUID().uuidString, title: title))
    }
    
    func schedule() -> Void {
        print("schedule 시작")
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission { granted in
                    if granted {
                        self.scheduleNotifications()
                    }
                }
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                print("알림 권한이 거부되었습니다.")
            }
        }
    }
    
//    func scheduleNotifications() -> Void {
//        print("스케줄링 시작: \(notifications.count)개의 알림")
//        
//        for notification in notifications {
//            // 현재 시간으로부터 1분 뒤로 설정
//            let calendar = Calendar.current
//            let now = Date()
//            let oneMinuteLater = calendar.date(byAdding: .minute, value: 1, to: now)!
//            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: oneMinuteLater)
//            
//            var dateComponents = DateComponents()
//            dateComponents.calendar = Calendar.current
//            dateComponents.year = components.year
//            dateComponents.month = components.month
//            dateComponents.day = components.day
//            dateComponents.hour = components.hour
//            dateComponents.minute = components.minute
//            
//            print("알림 예정 시간: \(dateComponents)")
//            
//            let content = UNMutableNotificationContent()
//            content.title = notification.title.isEmpty ? "약 먹을 시간" : notification.title
//            content.sound = UNNotificationSound.default
//            content.subtitle = "약먹을 시간이에요"
//            content.body = "약먹었다"
//            
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
//            
//            UNUserNotificationCenter.current().add(request) { error in
//                if let error = error {
//                    print("알림 스케줄링 실패: \(error)")
//                } else {
//                    print("알림 스케줄링 성공: \(notification.id)")
//                }
//            }
//        }
//    }
    
    func scheduleNotifications() -> Void {
        print("스케줄링 시작: \(notifications.count)개의 알림")
        
        for notification in notifications {
            let calendar = Calendar.current
            let now = Date() // 현재 시간
            print("현재 시간: \(now)")
            
            // 현재 시간으로부터 1분 후로 설정
            guard let scheduledDate = calendar.date(byAdding: .minute, value: 1, to: now) else {
                print("날짜 계산 실패")
                return
            }
            
            let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: scheduledDate)
            print("설정된 알림 시간: \(scheduledDate)")
            
            let content = UNMutableNotificationContent()
            content.title = notification.title.isEmpty ? "약 먹을 시간" : notification.title
            content.sound = UNNotificationSound.default
            content.subtitle = "약먹을 시간이에요"
            content.body = "약먹었다"
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("알림 스케줄링 실패: \(error)")
                } else {
                    print("알림 스케줄링 성공: \(notification.id)")
                    // 현재 등록된 알림 확인
                    UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                        print("현재 등록된 알림 개수: \(requests.count)")
                        requests.forEach { request in
                            if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                                print("등록된 알림 시간: \(trigger.dateComponents)")
                            }
                        }
                    }
                }
            }
        }
    }
}

