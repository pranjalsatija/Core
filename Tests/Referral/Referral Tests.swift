//
//  Referral Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/14/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import XCTest
@testable import Core

class ReferralTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testCreate() throws {
        var didSave = false
        let sender = PFUser(), receiver = PFUser()

        MockAPI.onSave {(object) in
            guard let referral = object as? Referral else { return }
            XCTAssert(referral.sender == sender)
            XCTAssert(referral.receiver == receiver)
            didSave = true
        }

        Referral.create(sender: sender, receiver: receiver, api: MockAPI.self)
        XCTAssert(didSave)
    }
}
