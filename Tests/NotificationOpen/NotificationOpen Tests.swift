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
        var didSave = false
        let user = PFUser()

        MockAPI.onSave {(object) in
            guard let notificationOpen = object as? NotificationOpen else { return }
            XCTAssert(notificationOpen.acl == .onlyAccessibleByMasterKey)
            XCTAssert(notificationOpen.user == user)
            didSave = true
        }

        NotificationOpen.create(with: user, userInfo: [:], api: MockAPI.self)
        XCTAssert(didSave)
    }
}
