//
//  Referral Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/14/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import XCTest

class ReferralTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testCreate() throws {
        let saveExpectation = expectation(description: "expectation")
        let sender = PFUser(), receiver = PFUser()
        let event = Event()

        MockAPI.onSave {(object) in
            guard let referral = object as? Referral else {
                XCTFail()
                return
            }

            XCTAssert(referral.sender == sender)
            XCTAssert(referral.receiver == receiver)
            XCTAssert(referral.event == event)
            saveExpectation.fulfill()
        }

        Referral.create(sender: sender, receiver: receiver, event: event, using: MockAPI.self)
        waitForExpectations(timeout: 3)
    }
}
