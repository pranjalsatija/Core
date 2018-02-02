//
//  PFUser+Report Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/20/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import XCTest

class PFUserReportTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testCreate() {
        let saveExpectation = expectation(description: "Save")
        let user = PFUser(), event = Event(), reason = Report.Reason.spammy

        MockAPI.onSave {(object) in
            guard let report = object as? Report else {
                XCTFail()
                return
            }

            XCTAssert(report.event == event)
            XCTAssert(report.reason == reason.rawValue)
            XCTAssert(report.user == user)
            saveExpectation.fulfill()
        }

        user.report(event, reason: reason, using: MockAPI.self)
        waitForExpectations(timeout: 3)
    }
}
