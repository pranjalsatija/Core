//
//  CLLocation+LocationProtocol.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/15/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import CoreLocation
import XCTest

class CLLocationCoordinate2DTests: XCTestCase {
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
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }

        for (index, location) in locations.enumerated() {
            XCTAssert(location.latitude == points[index].latitude)
            XCTAssert(location.longitude == points[index].longitude)
        }
    }

    func testInitializers() {
        for (latitude, longitude) in points {
            let fromCLLocation = CLLocationCoordinate2D(CLLocation(latitude: latitude, longitude: longitude))
            let fromLocation = CLLocationCoordinate2D(Location(latitude: latitude, longitude: longitude))
            let fromGeoPoint = CLLocationCoordinate2D(PFGeoPoint(latitude: latitude, longitude: longitude))

            for location in [fromCLLocation, fromLocation, fromGeoPoint] {
                XCTAssert(location.latitude == latitude)
                XCTAssert(location.longitude == longitude)
            }
        }
    }
}
