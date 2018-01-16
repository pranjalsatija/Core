//
//  Session Tests.swift
//  Core
//
//  Created by Pranjal Satija on 1/12/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import XCTest
@testable import Core

class SessionTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testCreateWithUser() throws {
        let saveExpectation = expectation(description: "expectation")
        let user = PFUser()

        MockAPI.onSave {(object) in
            guard let session = object as? Session else { return }
            XCTAssert(session.acl == .onlyAccessibleByMasterKey)
            XCTAssert(session.user == user)
            saveExpectation.fulfill()
        }

        Session.create(with: user, api: MockAPI.self)
        waitForExpectations(timeout: 3)
    }

    func testEndSessionWithUser() throws {
        let saveExpectation = expectation(description: "save"), queryExpectation = expectation(description: "query")
        let user = PFUser(), session = Session(user: user, startDate: Date())

        MockAPI.onSave {(object) in
            guard let session = object as? Session else { return }
            XCTAssert(session.user == user)
            saveExpectation.fulfill()
        }

        MockAPI.onQuery {(query) in
            XCTAssert(PFQueryGetSortKeys(query)?.contains("-startDate") ?? false)
            XCTAssert(PFQueryGetConditions(query)?["user"] != nil)
            XCTAssert(PFQueryGetConditions(query)?["endDate"] != nil)
            queryExpectation.fulfill()
            return [session]
        }

        Session.endLatest(belongingTo: user, api: MockAPI.self)
        waitForExpectations(timeout: 3)
    }

    func testNegativeEndSessionWithUser() throws {
        let queryExpectation = expectation(description: "query")
        let user = PFUser()

        MockAPI.onSave {(_) in
            XCTFail("The session shouldn't be saved.")
        }

        MockAPI.onQuery {(query) in
            XCTAssert(PFQueryGetSortKeys(query)?.contains("-startDate") ?? false)
            XCTAssert(PFQueryGetConditions(query)?["user"] != nil)
            XCTAssert(PFQueryGetConditions(query)?["endDate"] != nil)

            queryExpectation.fulfill()

            return []
        }

        Session.endLatest(belongingTo: user, api: MockAPI.self)
        waitForExpectations(timeout: 3)
    }
}
