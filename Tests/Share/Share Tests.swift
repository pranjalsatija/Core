//
//  Share Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/14/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import XCTest

class ShareTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testCreate() {
        let saveExpectation = expectation(description: "save")
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

        Share.create(user: user, event: event, api: MockAPI.self)
        waitForExpectations(timeout: 3)
    }
}
