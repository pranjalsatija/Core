//
//  Share Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/14/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import XCTest
@testable import Core

class ShareTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testCreate() {
        let saveExpectation = expectation(description: "save")
        let user = PFUser()

        MockAPI.onSave {(object) in
            guard let share = object as? Share else { return }
            XCTAssert(share.user == user)
            saveExpectation.fulfill()
        }

        Share.create(user: user, api: MockAPI.self)
        waitForExpectations(timeout: 3)
    }
}
