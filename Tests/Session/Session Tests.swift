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
        var didSave = false
        let user = PFUser()

        MockAPI.onSave {(object) in
            guard let session = object as? Session, session.user == user else { return }
            didSave = true
        }

        Session.create(with: user, api: MockAPI.self)
        XCTAssert(didSave)
    }

    func testEndSessionWithUser() throws {
        let saveExpectation = expectation(description: "save"), queryExpectation = expectation(description: "query")
        var didSave = false, didQuery = false
        let user = PFUser(), session = Session(user: user, startDate: Date())

        MockAPI.onSave {(object) in
            guard let session = object as? Session, session.user == user else { return }
            didSave = true
            saveExpectation.fulfill()
        }

        MockAPI.onQuery {(query) in
            XCTAssert(PFQueryGetSortKeys(query)?.contains("-startDate") ?? false)
            XCTAssert(PFQueryGetConditions(query)?["user"] != nil)
            XCTAssert(PFQueryGetConditions(query)?["endDate"] != nil)

            didQuery = true
            queryExpectation.fulfill()

            return [session]
        }

        Session.endLatest(belongingTo: user, api: MockAPI.self)
        waitForExpectations(timeout: 3)
        XCTAssert(didSave)
        XCTAssert(didQuery)
    }
}
