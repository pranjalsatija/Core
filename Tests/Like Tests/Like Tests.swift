//
//  Like Tests.swift
//  Core
//
//  Created by Pranjal Satija on 1/18/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import XCTest

class LikeTests: XCTestCase {
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

        Like.create(event: event, user: user, using: MockAPI.self)
    }

    func testExists() {
        let queryExpectation = expectation(description: "Query")

        let event = Event()
        let user = PFUser()

        MockAPI.onQuery {(_) in
            return [Like(event: event, user: user)]
        }

        Like.exists(user: user, event: event, using: MockAPI.self) {(_, exists) in
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
