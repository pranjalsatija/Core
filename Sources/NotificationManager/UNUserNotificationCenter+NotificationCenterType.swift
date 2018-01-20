//
//  UNUserNotificationCenter+NotificationCenterType.swift
//  Core
//
//  Created by Pranjal Satija on 1/19/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UserNotifications

extension UNUserNotificationCenter: NotificationCenterType {
    public func add(_ request: UNNotificationRequest, completion: ((Swift.Error?) -> Void)?) {
        add(request, withCompletionHandler: completion)
    }

    public func getPendingNotificationRequests(completion: @escaping ([UNNotificationRequest]) -> Void) {
        getPendingNotificationRequests(completionHandler: completion)
    }

    public func getAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        getNotificationSettings {(settings) in
            main { completion(settings.authorizationStatus) }
        }
    }

    public func remove(_ requests: [UNNotificationRequest]) {
        removePendingNotificationRequests(withIdentifiers: requests.map { $0.identifier })
    }

    public func requestAuthorization(options: UNAuthorizationOptions,
                                     completion: @escaping (Swift.Error?, Bool) -> Void) {

        requestAuthorization(options: options) {(wasAuthorized, error) in
            main { completion(error, wasAuthorized) }
        }
    }
}
