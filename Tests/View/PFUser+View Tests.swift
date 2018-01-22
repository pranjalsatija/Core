//
//  PFUser+View.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/21/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import XCTest

class PFUserViewTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testCreate() {
        let saveExpectation = expectation(description: "expectation")
        let event = Event(), user = PFUser()

        MockAPI.onSave {(object) in
            guard let view = object as? View else {
                XCTFail()
                return
            }

            XCTAssert(view.event == event)
            XCTAssert(view.user == user)
            saveExpectation.fulfill()
        }

        user.markAsViewed(event, using: MockAPI.self)
        waitForExpectations(timeout: 3)
    }
}
