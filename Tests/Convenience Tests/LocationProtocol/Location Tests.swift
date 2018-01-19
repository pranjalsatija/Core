//
//  Location Tests.swift
//  Core
//
//  Created by Pranjal Satija on 1/15/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import CoreLocation
import XCTest
@testable import Core

class LocationTests: XCTestCase {
    let points: [(latitude: Double, longitude: Double)] = [
        (32.7767, -96.7970), // Dallas
        (29.761993, -95.366302), // Houston
        (30.2672, -97.7431), // Austin
        (29.4241, -98.4936) // San Antonio
    ]

    override func setUp() {
        performSetupIfNeeded()
    }

    func testEquality() {
        let locations: [LocationType] = points.map {(latitude, longitude) in
            Location(latitude: latitude, longitude: longitude)
        }

        for (index, location) in locations.enumerated() {
            XCTAssert(location.latitude == points[index].latitude)
            XCTAssert(location.longitude == points[index].longitude)
        }
    }

    func testInitializer() {
        for (latitude, longitude) in points {
            let fromCLLocation = Location(CLLocation(latitude: latitude, longitude: longitude))
            let fromLocationCoordinate = Location(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            let fromGeoPoint = Location(PFGeoPoint(latitude: latitude, longitude: longitude))

            for location in [fromCLLocation, fromLocationCoordinate, fromGeoPoint] {
                XCTAssert(location.latitude == latitude)
                XCTAssert(location.longitude == longitude)
            }
        }
    }
}
