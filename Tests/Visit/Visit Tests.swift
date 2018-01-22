//
//  Visit Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/21/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import XCTest

class VisitTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testCreate() throws {
        let saveExpectation = expectation(description: "Save")
        let event = Event(), user = User(withoutDataWithObjectId: "testUser")

        MockAPI.onSave {(object) in
            guard let visit = object as? Visit else {
                XCTFail()
                return
            }

            XCTAssert(visit.event == event)
            XCTAssert(visit.user == user)
            saveExpectation.fulfill()
        }

        Visit.create(with: event, user: user, using: MockAPI.self)
        waitForExpectations(timeout: 3)
    }

    func testGetVisits() {
        let queryExpectation = expectation(description: "Query")
        let event = Event(), user = User(withoutDataWithObjectId: "testUser")

        let testVisits = [
            Visit(event: event, user: user),
            Visit(event: event, user: user),
            Visit(event: event, user: user)
        ]

        MockAPI.onQuery {(_) in
            return testVisits
        }

        Visit.getVisits(forUser: user, using: MockAPI.self) {(_, visits) in
            guard let visits = visits else {
                XCTFail()
                return
            }

            XCTAssert(visits == testVisits)
            queryExpectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }
}
