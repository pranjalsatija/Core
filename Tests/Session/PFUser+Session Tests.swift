//
//  PFUser+Session Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/13/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import XCTest
@testable import Core

class PFUserSessionTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testStart() throws {
        let saveExpectation = expectation(description: "expectation")
        let user = PFUser()

        MockAPI.onSave {(object) in
            guard let session = object as? Session else { return }
            XCTAssert(session.acl == .onlyAccessibleByMasterKey)
            XCTAssert(session.user == user)
            saveExpectation.fulfill()
        }

        user.startSession(api: MockAPI.self)
        waitForExpectations(timeout: 3)
    }

    func testEndLatest() throws {
        let saveExpectation = expectation(description: "save"), queryExpectation = expectation(description: "query")
        let user = PFUser(), session = Session(user: user, startDate: Date())

        MockAPI.onSave {(object) in
            guard let session = object as? Session, session.user == user else { return }
            saveExpectation.fulfill()
        }

        MockAPI.onQuery {(query) in
            XCTAssert(PFQueryGetSortKeys(query)?.contains("-startDate") ?? false)
            XCTAssert(PFQueryGetConditions(query)?["user"] != nil)
            XCTAssert(PFQueryGetConditions(query)?["endDate"] != nil)
            queryExpectation.fulfill()
            return [session]
        }

        user.endLatestSession(api: MockAPI.self)
        waitForExpectations(timeout: 3)
    }
}
