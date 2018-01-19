//
//  PFUser+Referral Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/14/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import XCTest

class PFUserReferralTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testRegisterFromSender() throws {
        let saveExpectation = expectation(description: "expectation")
        let sender = PFUser(), receiver = PFUser()
        let event = Event()

        MockAPI.onSave {(object) in
            guard let referral = object as? Referral else {
                XCTFail()
                return
            }

            XCTAssert(referral.acl == .onlyAccessibleByMasterKey)
            XCTAssert(referral.sender == sender)
            XCTAssert(referral.receiver == receiver)
            XCTAssert(referral.event == event)
            saveExpectation.fulfill()
        }

        receiver.registerReferral(from: sender, with: event, api: MockAPI.self)
        waitForExpectations(timeout: 3)
    }
}
