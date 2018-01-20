//
//  NotificationManager Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/19/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import UserNotifications
import XCTest

class NotificationManagerTests: XCTestCase {
    var notificationCenter = MockNotificationCenter()

    func makeRequests(titles: [String], bodies: [String]) -> [UNNotificationRequest] {
        XCTAssert(titles.count == bodies.count)

        let contents: [UNMutableNotificationContent] = zip(titles, bodies).map {(title, body) in
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            return content
        }

        return contents.map {(content) in
            UNNotificationRequest(identifier: content.title, content: content, trigger: nil)
        }
    }

    func testGetAuthorizationStatus() {
        let expectedStatus = UNAuthorizationStatus.authorized
        notificationCenter.onGetAuthorizationStatus {
            return expectedStatus
        }

        NotificationManager.getAuthorizationStatus(from: notificationCenter) {(status) in
            XCTAssert(status == expectedStatus)
        }
    }

    func testRemoveRequestsMatchingPredicate() {
        let titles = [
            "#remove Test Notification 1",
            "#include Test Notification 2",
            "#remove Test Notification 3",
            "#include Test Notification 4"
        ], bodies = [
            "This is the first test notification.",
            "This is the second test notification.",
            "This is the third test notification.",
            "This is the fourth test notification."
        ], requests = makeRequests(titles: titles, bodies: bodies)

        let predicate: (UNNotificationRequest) -> Bool = {(request) in
            return request.content.title.hasPrefix("#remove")
        }

        notificationCenter.onGetRequests {
            return requests
        }

        notificationCenter.onRemoveRequests {(requestsBeingRemoved) in
            XCTAssert(requestsBeingRemoved == requests.filter(predicate))
        }

        NotificationManager.removeAllRequests(where: predicate, from: notificationCenter)
    }

    func testRemoveRequestWithID() {
        let titles = [
            "#removeThisRequest",
            "Test Notification 2",
            "Test Notification 3",
            "Test Notification 4"
        ], bodies = [
            "This is the first test notification.",
            "This is the second test notification.",
            "This is the third test notification.",
            "This is the fourth test notification."
        ], requests = makeRequests(titles: titles, bodies: bodies)

        let predicate: (UNNotificationRequest) -> Bool = {(request) in
            return request.identifier == "#removeThisRequest"
        }

        notificationCenter.onGetRequests {
            return requests
        }

        notificationCenter.onRemoveRequests {(requestsBeingRemoved) in
            XCTAssert(requestsBeingRemoved == requests.filter(predicate))
        }

        NotificationManager.removeRequest(withID: "#removeThisRequest", from: notificationCenter)
    }

    func testRequestAuthorization() {
        let requestExpectation = expectation(description: "Request Authorization")

        notificationCenter.onAuthorizationRequest {
            return (nil, true)
        }

        NotificationManager.requestAuthorization(from: notificationCenter) {(error, wasAuthorized) in
            XCTAssert(error == nil)
            XCTAssert(wasAuthorized)
            requestExpectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    func testRequestExists() {
        let queryExpectation = expectation(description: "Query Requests")

        let titles = [
            "testID"
        ], bodies = [
            "This is the first test notification."
        ], requests = makeRequests(titles: titles, bodies: bodies)

        notificationCenter.onGetRequests {
            return requests
        }

        NotificationManager.requestExists(withID: "testID", in: notificationCenter) {(exists) in
            XCTAssert(exists)
            queryExpectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    func testScheduleAtDate() {
        let now = Date(), triggerDate = now.addingTimeInterval(15.seconds)
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "This is a test notification."

        notificationCenter.onAddRequest {(request) in
            guard let trigger = request.trigger as? UNTimeIntervalNotificationTrigger else {
                XCTFail()
                return
            }

            XCTAssert(request.content == content)
            XCTAssert(request.identifier == "testSchedule")

            let correctInterval = triggerDate.timeIntervalSince(now)
            let correctIntervalRange = (0.99 * correctInterval)...(1.01 * correctInterval)
            XCTAssert(correctIntervalRange.contains(trigger.timeInterval))
        }

        NotificationManager.schedule(content,
                                     at: triggerDate,
                                     withID: "testSchedule",
                                     using: notificationCenter)
    }

    func testScheduleAtDateWithInvalidDate() {
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "This is a test notification."

        notificationCenter.onAddRequest {(_) in
            XCTFail()
        }

        NotificationManager.schedule(content,
                                     at: Date().addingTimeInterval(-15.seconds),
                                     withID: "testSchedule",
                                     using: notificationCenter)
    }

    func testScheduleAtRegion() {
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "This is a test notification."

        let dallas = CLLocationCoordinate2D(latitude: 32.7767, longitude: -96.7970)
        let region = CLCircularRegion(center: dallas, radius: 500, identifier: "test")

        notificationCenter.onAddRequest {(request) in
            guard let trigger = request.trigger as? UNLocationNotificationTrigger else {
                XCTFail()
                return
            }

            XCTAssert(request.content == content)
            XCTAssert(request.identifier == "testSchedule")
            XCTAssert(trigger.region == region)
        }

        NotificationManager.schedule(content, at: region, withID: "testSchedule", using: notificationCenter)
    }
}
