//
//  PFUser+Share Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/15/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import XCTest
@testable import Core

class PFUserShareTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testRegister() throws {
        let saveExpectation = expectation(description: "expectation")
        let user = PFUser()

        MockAPI.onSave {(object) in
            guard let share = object as? Share else { return }
            XCTAssert(share.user == user)
            saveExpectation.fulfill()
        }

        user.registerShare(api: MockAPI.self)
        waitForExpectations(timeout: 3)
    }
}
