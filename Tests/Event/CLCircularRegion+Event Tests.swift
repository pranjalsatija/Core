//
//  CLCircularRegion+Event Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/16/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import XCTest

class CLCircularRegionEventTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testInitializer() {
        let event = Event()
        event.location = PFGeoPoint(latitude: 32.7767, longitude: -96.7970)
        event.radius = 50

        let region = CLCircularRegion(event: event, identifier: "testRegion")
        XCTAssert(region.center.latitude == event.location.latitude)
        XCTAssert(region.center.longitude == event.location.longitude)
        XCTAssert(region.radius == event.radius.doubleValue)
    }
}
