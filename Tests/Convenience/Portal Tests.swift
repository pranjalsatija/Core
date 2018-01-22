//
//  Portal Tests.swift
//  Core
//
//  Created by Pranjal Satija on 1/20/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import XCTest

class PortalTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testInitializer() {
        let testName = "testInitializer Portal"
        let portal = Portal<Void>(name: testName)
        XCTAssert(portal.name == testName)
    }

    func testInvalidUpdate() {
        let testName = "testInvalidUpdate portal"
        let portal = Portal<String>(name: testName)

        portal.observeUpdates {(_) in
            XCTFail()
        }

        Portal(name: testName).update(5)
    }

    func testOpeningMultiplePortals() {
        let testName = "testOpeningMultiplePortals Portal", testUpdate = "TestUpdate"
        let portal1Expectation = expectation(description: "Portal 1")
        let portal2Expectation = expectation(description: "Portal 2")

        let portal1 = Portal<String>(name: testName)
        let portal2 = Portal<String>(name: testName)

        portal1.observeUpdates {(update) in
            XCTAssert(update == testUpdate)
            portal1Expectation.fulfill()
        }

        portal2.observeUpdates {(update) in
            XCTAssert(update == testUpdate)
            portal2Expectation.fulfill()
        }

        Portal(name: testName).update(testUpdate)
        waitForExpectations(timeout: 3)
    }
}
