//
//  MockNotificationCenter.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/19/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import UserNotifications
import XCTest

/// Used as a mock for `UNUserNotificationCenter.shared()` during unit testing.
struct MockNotificationCenter {
    typealias AddRequestHandler = (UNNotificationRequest) throws -> Void
    typealias GetRequestsHandler = () -> [UNNotificationRequest]
    typealias GetAuthorizationStatusHandler = () -> UNAuthorizationStatus
    typealias RemoveRequestsHandler = ([UNNotificationRequest]) -> Void
    typealias RequestAuthorizationHandler = () -> (Swift.Error?, Bool)

    var addRequestHandler: AddRequestHandler?
    var getRequestsHandler: GetRequestsHandler?
    var getAuthorizationStatusHandler: GetAuthorizationStatusHandler?
    var removeRequestsHandler: RemoveRequestsHandler?
    var requestAuthorizationHandler: RequestAuthorizationHandler?
}

// MARK: Catching UNUserNotificationCenter Requests
extension MockNotificationCenter {
    mutating func onAddRequest(_ block: @escaping AddRequestHandler) {
        addRequestHandler = block
    }

    mutating func onGetRequests(_ block: @escaping GetRequestsHandler) {
        getRequestsHandler = block
    }

    mutating func onGetAuthorizationStatus(_ block: @escaping GetAuthorizationStatusHandler) {
        getAuthorizationStatusHandler = block
    }

    mutating func onRemoveRequests(_ block: @escaping RemoveRequestsHandler) {
        removeRequestsHandler = block
    }

    mutating func onAuthorizationRequest(_ block: @escaping RequestAuthorizationHandler) {
        requestAuthorizationHandler = block
    }
}

// MARK: NotificationCenterType
extension MockNotificationCenter: NotificationCenterType {
    func add(_ request: UNNotificationRequest, completion: ((Swift.Error?) -> Void)?) {
        do {
            try addRequestHandler?(request)
            completion?(nil)
        } catch {
            completion?(error)
        }
    }

    func getPendingNotificationRequests(completion: @escaping ([UNNotificationRequest]) -> Void) {
        if let requests = getRequestsHandler?() {
            completion(requests)
        } else {
            print("MockNotificationCenter.getPendingNotificationRequests was called, but no handler was provided.")
        }
    }

    func getAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        if let settings = getAuthorizationStatusHandler?() {
            completion(settings)
        } else {
            print("MockNotificationCenter.getNotificationSettings was called, but no handler was provided.")
        }
    }

    func remove(_ requests: [UNNotificationRequest]) {
        removeRequestsHandler?(requests)
    }

    func requestAuthorization(options: UNAuthorizationOptions, completion: @escaping (Swift.Error?, Bool) -> Void) {
        guard let (error, wasAuthorized) = requestAuthorizationHandler?() else {
            print("MockNotificationCenter.requestAuthorization was called, but no handler was provided.")
            return
        }

        completion(error, wasAuthorized)
    }
}
