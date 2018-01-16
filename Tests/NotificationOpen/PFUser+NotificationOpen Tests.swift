//
//  PFUser+NotificationOpen Tests.swift
//  Core
//
//  Created by Pranjal Satija on 1/13/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import XCTest
@testable import Core

class PFUserNotificationOpenTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testRegisterWithUserInfo() throws {
        let saveExpectation = expectation(description: "expectation")
        let user = PFUser(), event = Event(pointerWithObjectID: "abcxyz")

        MockAPI.onSave {(object) in
            guard let notificationOpen = object as? NotificationOpen else { return }
            XCTAssert(notificationOpen.acl == .onlyAccessibleByMasterKey)
            XCTAssert(notificationOpen.user == user)
            XCTAssert(notificationOpen.event == event)
            saveExpectation.fulfill()
        }

        user.registerNotificationOpen(userInfo: [
            "event": "abcxyz"
        ], api: MockAPI.self)

        waitForExpectations(timeout: 3)
    }
}
