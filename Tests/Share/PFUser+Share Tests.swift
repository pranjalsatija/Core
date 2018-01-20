//
//  PFUser+Share Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/15/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import XCTest

class PFUserShareTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testRegister() throws {
        let saveExpectation = expectation(description: "expectation")
        let user = PFUser(), event = Event()

        MockAPI.onSave {(object) in
            guard let share = object as? Share else {
                XCTFail()
                return
            }

            XCTAssert(share.user == user)
            XCTAssert(share.event == event)
            saveExpectation.fulfill()
        }

        user.registerShare(with: event, using: MockAPI.self)
        waitForExpectations(timeout: 3)
    }
}
