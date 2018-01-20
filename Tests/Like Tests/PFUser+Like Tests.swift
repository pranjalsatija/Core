//
//  PFUser+Like Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/18/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import XCTest

class PFUserLikeTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testCreate() {
        let event = Event()
        let user = PFUser()

        MockAPI.onSave {(object) in
            guard let like = object as? Like else {
                XCTFail()
                return
            }

            XCTAssert(like.event == event)
            XCTAssert(like.user == user)
        }

        user.like(event: event, api: MockAPI.self)
    }

    func testExists() {
        let queryExpectation = expectation(description: "Query")
        let event = Event()
        let user = PFUser()

        MockAPI.onQuery {(_) in
            return [Like(event: event, user: user)]
        }

        user.hasLiked(event: event, api: MockAPI.self) {(_, exists) in
            guard let exists = exists else {
                XCTFail()
                return
            }

            XCTAssert(exists)
            XCTAssert(Thread.isMainThread)
            queryExpectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }
}
