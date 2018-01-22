//
//  User+Event Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/21/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import XCTest

class UserEventTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testUserIsAtEvent() {
        let dallas = Location(latitude: 32.7767, longitude: -96.7970)

        let event = Event()
        event.location = PFGeoPoint(dallas)
        event.radius = 500

        let user = User()
        user.location = Portal(name: "userLocationPortal")
        user.location.update(dallas)

        XCTAssert(user.isAt(event))
    }
}
