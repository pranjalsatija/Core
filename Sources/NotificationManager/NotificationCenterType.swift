//
//  NotificationCenterType.swift
//  Core
//
//  Created by Pranjal Satija on 1/18/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UserNotifications

/// A protocol for types that support notification operations.
public protocol NotificationCenterType {
    func add(_ request: UNNotificationRequest, completion: ((Swift.Error?) -> Void)?)
    func getAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void)
    func getPendingNotificationRequests(completion: @escaping ([UNNotificationRequest]) -> Void)
    func remove(_ requests: [UNNotificationRequest])
    func requestAuthorization(options: UNAuthorizationOptions, completion: @escaping (Swift.Error?, Bool) -> Void)
}
