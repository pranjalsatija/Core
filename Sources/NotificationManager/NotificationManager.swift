//
//  NotificationManager.swift
//  Core
//
//  Created by Pranjal Satija on 1/19/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UserNotifications

/// Used to schedule local notifications.
public struct NotificationManager {
    public static var shared: NotificationCenterType = UNUserNotificationCenter.current()
}

// MARK: Authorization
public extension NotificationManager {
    /// Gets the current notification authorization status, as provided by the specified notification center.
    static func getAuthorizationStatus(from notificationCenter: NotificationCenterType = shared,
                                       completion: @escaping (UNAuthorizationStatus) -> Void) {

        notificationCenter.getAuthorizationStatus(completion: completion)
    }

    /// Requests authorization with the specified notification center.
    static func requestAuthorization(from notificationCenter: NotificationCenterType = shared,
                                     completion: @escaping (Swift.Error?, Bool) -> Void) {

        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound], completion: completion)
    }
}

// MARK: Requests
public extension NotificationManager {
    /// Removes all the pending requests with location triggers in the specified notification center.
    static func removeAllRequests(where predicate: @escaping ((UNNotificationRequest) -> Bool),
                                  from notificationCenter: NotificationCenterType = shared) {

        notificationCenter.getPendingNotificationRequests {(requests) in
            notificationCenter.remove(requests.filter(predicate))
        }
    }

    /// Removes a specific request from the specified notification center.
    static func removeRequest(withID id: String, from notificationCenter: NotificationCenterType = shared) {
        removeAllRequests(where: { $0.identifier == id }, from: notificationCenter)
    }

    /// Checks if a request with the specified ID exists in the specified notification center.
    static func requestExists(withID id: String,
                              in notificationCenter: NotificationCenterType = shared,
                              completion: @escaping (Bool) -> Void) {

        notificationCenter.getPendingNotificationRequests {(requests) in
            completion(requests.contains { $0.identifier == id })
        }
    }

    /// Schedules the provided notification content at a specified date in the provided notification center.
    static func schedule(_ content: UNNotificationContent,
                         at date: Date,
                         withID id: String,
                         using notificationCenter: NotificationCenterType = shared) {

        guard date.timeIntervalSinceNow > 0 else {
            return
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSinceNow, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        notificationCenter.add(request, completion: nil)
    }

    /// Schedules the provided notification content at a specified location in the provided notification center.
    static func schedule(_ content: UNNotificationContent,
                         at region: CLRegion,
                         withID id: String,
                         using notificationCenter: NotificationCenterType = shared) {

        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        notificationCenter.add(request, completion: nil)
    }
}
