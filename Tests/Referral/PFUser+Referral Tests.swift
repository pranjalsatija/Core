//
//  PFUser+Referral Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/14/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import XCTest
@testable import Core

class PFUserReferralTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testRegisterFromSender() throws {
        let saveExpectation = expectation(description: "expectation")
        let sender = PFUser(), receiver = PFUser()

        MockAPI.onSave {(object) in
            guard let referral = object as? Referral else { return }
            XCTAssert(referral.sender == sender)
            XCTAssert(referral.receiver == receiver)
            saveExpectation.fulfill()
        }

        receiver.registerReferral(from: sender, api: MockAPI.self)
        waitForExpectations(timeout: 3)
    }
}
