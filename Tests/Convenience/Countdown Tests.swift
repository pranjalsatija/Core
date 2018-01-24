//
//  Countdown Tests.swift
//  Core
//
//  Created by Pranjal Satija on 1/23/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import XCTest

class CountdownTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testInitializer() {
        let countdownExpectation = expectation(description: "Countdown")
        let duration = 3.0, startTime = CFAbsoluteTimeGetCurrent()

        let countdown = Countdown(duration: duration) {
            let elapsedTime = CFAbsoluteTimeGetCurrent() - startTime
            XCTAssert((0.9 * duration...1.1 * duration).contains(elapsedTime))
            countdownExpectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(!countdown.timer.isValid)
    }

    func testStart() {
        let countdownExpectation = expectation(description: "Countdown")
        let duration = 3.0, startTime = CFAbsoluteTimeGetCurrent()

        let countdown = Countdown.start(duration: duration) {
            let elapsedTime = CFAbsoluteTimeGetCurrent() - startTime
            XCTAssert((0.9 * duration...1.1 * duration).contains(elapsedTime))
            countdownExpectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(!countdown.timer.isValid)
    }
}
