//
//  Location Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/14/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import CoreLocation
import XCTest
@testable import Core

class LocationTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testLocation() {
        let points: [(latitude: Double, longitude: Double)] = [
            (32.7767, -96.7970), // Dallas
            (29.761993, -95.366302), // Houston
            (30.2672, -97.7431), // Austin
            (29.4241, -98.4936) // San Antonio
        ]

        let coordinates: [Location] = points.map {(latitude, longitude) in
            CLLocationCoordinate2DMake(latitude, longitude)
        }

        let locations: [Location] = points.map {(latitude, longitude) in
            CLLocation(latitude: latitude, longitude: longitude)
        }

        let geoPoints: [Location] = points.map {(latitude, longitude) in
            PFGeoPoint(latitude: latitude, longitude: longitude)
        }

        let enumerated = [coordinates, locations, geoPoints].flatMap { $0.enumerated() }
        for (index, location) in enumerated {
            XCTAssert(location.latitude == points[index].latitude)
            XCTAssert(location.longitude == points[index].longitude)
        }
    }
}
