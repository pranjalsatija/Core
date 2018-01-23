//
//  UserError Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/21/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import XCTest

class UserErrorTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testErrorCodes() {
        XCTAssert(UserError.invalidPhoneNumber.code == 141)
        XCTAssert(UserError.invalidPIN.code == 101)
    }
}
