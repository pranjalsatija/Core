//
//  PFUser+Session Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/13/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import XCTest

class PFUserSessionTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testStart() throws {
        let saveExpectation = expectation(description: "expectation")
        let user = PFUser()

        MockAPI.onSave {(object) in
            guard let session = object as? Session else {
                XCTFail()
                return
            }

            XCTAssert(session.user == user)
            saveExpectation.fulfill()
        }

        user.startSession(using: MockAPI.self)
        waitForExpectations(timeout: 3)
    }

    func testEndLatest() throws {
        let saveExpectation = expectation(description: "save"), queryExpectation = expectation(description: "query")
        let user = PFUser(), session = Session(user: user, startDate: Date())

        MockAPI.onSave {(object) in
            guard let session = object as? Session else {
                XCTFail()
                return
            }

            XCTAssert(session.user == user)
            saveExpectation.fulfill()
        }

        MockAPI.onQuery {(_) in
            queryExpectation.fulfill()
            return [session]
        }

        user.endLatestSession(using: MockAPI.self)
        waitForExpectations(timeout: 3)
    }
}
