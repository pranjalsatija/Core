//
//  CloudFunction Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/21/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import XCTest

class CloudFunctionTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testFunctions() throws {
        XCTAssert(CloudFunction.beginPhoneNumberAuthentication.name == "beginPhoneNumberAuth")
        XCTAssert(CloudFunction.finishPhoneNumberAuthentication.name == "finishPhoneNumberAuth")
    }
}
