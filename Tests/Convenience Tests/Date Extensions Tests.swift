//
//  Date Extensions Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/16/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import XCTest
@testable import Core

class DateExtensionsTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testDateExtensions() {
        XCTAssert(30.seconds == 30)
        XCTAssert(30.minutes == 30 * 60)
        XCTAssert(30.hours == 30 * 60 * 60)
        XCTAssert(30.days == 30 * 60 * 60 * 24)
        XCTAssert(30.weeks == 30 * 60 * 60 * 24 * 7)
    }
}
