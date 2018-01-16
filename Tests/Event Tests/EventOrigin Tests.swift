//
//  EventOrigin Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/16/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import XCTest
@testable import Core

class EventOriginTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testInitializer() {
        XCTAssert(Event.Origin("eventbrite") == .eventbrite)
        XCTAssert(Event.Origin("eventful") == .eventful)
        XCTAssert(Event.Origin("foo") == nil)
    }
}
