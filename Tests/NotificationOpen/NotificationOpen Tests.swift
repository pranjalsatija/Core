//
//  NotificationOpen Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/13/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import XCTest
@testable import Core

class NotificationOpenTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testCreateWithUser() throws {
        let saveExpectation = expectation(description: "expectation")
        let user = PFUser()

        MockAPI.onSave {(object) in
            guard let notificationOpen = object as? NotificationOpen else { return }
            XCTAssert(notificationOpen.acl == .onlyAccessibleByMasterKey)
            XCTAssert(notificationOpen.user == user)
            saveExpectation.fulfill()
        }

        NotificationOpen.create(with: user, userInfo: [:], api: MockAPI.self)
        waitForExpectations(timeout: 3)
    }
}
