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
        var didSave = false
        let user = PFUser()

        MockAPI.onSave {(object) in
            guard let notificationOpen = object as? NotificationOpen else { return }
            XCTAssert(notificationOpen.acl == .onlyAccessibleByMasterKey)
            XCTAssert(notificationOpen.user == user)
            didSave = true
        }

        user.registerNotificationOpen(userInfo: [:], api: MockAPI.self)
        XCTAssert(didSave)
    }
}
