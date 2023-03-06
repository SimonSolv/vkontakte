//
//  LocalNotificationService.swift
//  Vkontakte
//
//  Created by Simon Pegg on 03.03.2023.
//

import UIKit
import Foundation
import UserNotifications

class LocalNotificationService: NSObject, UNUserNotificationCenterDelegate {
       
    let center = UNUserNotificationCenter.current()

    func registeForLatestUpdatesIfPossible() {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { result, error in
            if let error {
                print(error.localizedDescription)
                NotificationCenter.default.post(Notification(name: Notification.Name("AccessDenied")))
            } else {
                print("Access to notifications received")
                NotificationCenter.default.post(Notification(name: Notification.Name("AccessReceived")))
            }
        }
    }
    
    func registerNotification(title: String, body: String, hour: Int, min: Int) {
        let content = UNMutableNotificationContent()
        content.badge = (UIApplication.shared.applicationIconBadgeNumber + 1) as NSNumber
        content.title = title
        content.body = body
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = min
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true )
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerNotificationTimeInterval(title: String, body: String, interval: Double) {
        registerCategory()
        let content = UNMutableNotificationContent()
        content.badge = (UIApplication.shared.applicationIconBadgeNumber + 1) as NSNumber
        content.title = title
        content.body = body
        content.categoryIdentifier = "Demo"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategory() {
        center.delegate = self
        let actionShow =  UNNotificationAction(identifier: "Show", title: "Show")
        let actionDeny =  UNNotificationAction(identifier: "Deny", title: "Deny", options: [.destructive])
        let category = UNNotificationCategory(identifier: "Demo", actions: [actionShow, actionDeny], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "Show":
            DispatchQueue.main.async {
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
            print("Showing")
        case "Deny":
            DispatchQueue.main.async {
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
            print("Denied")
        default:
            DispatchQueue.main.async {
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
            print("Default option")
        }
        completionHandler()
    }
    
}
