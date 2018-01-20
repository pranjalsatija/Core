//
//  NotificationOpen Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/13/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import XCTest

class NotificationOpenTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testCreateWithUser() throws {
        let saveExpectation = expectation(description: "expectation")
        let user = PFUser(), event = Event(pointerWithObjectID: "abcxyz")

        MockAPI.onSave {(object) in
            guard let notificationOpen = object as? NotificationOpen else {
                XCTFail()
                return
            }
            XCTAssert(notificationOpen.acl == .onlyAccessibleByMasterKey)
            XCTAssert(notificationOpen.user == user)
            XCTAssert(notificationOpen.event == event)
            saveExpectation.fulfill()
        }

        NotificationOpen.create(with: user, userInfo: [
            "event": "abcxyz"
        ], using: MockAPI.self)
        waitForExpectations(timeout: 3)
    }
}
