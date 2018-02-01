//
//  LocationManager Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/25/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import XCTest

class LocationManagerTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testOnAuthorizationStatusChange() {
        let mockLocationManager = MockLocationManager()

        let statusUpdateExpectation = expectation(description: "Status Update")
        let status = CLAuthorizationStatus.authorizedAlways

        LocationManager.shared.onAuthorizationStatusChange(for: mockLocationManager) {(newStatus) in
            XCTAssert(newStatus == status)
            statusUpdateExpectation.fulfill()
        }

        mockLocationManager.updateAuthorizationStatus(status)

        waitForExpectations(timeout: 3)
    }

    func testNegativeTestOnAuthorizationStatusChange() {
        let mockLocationManager = MockLocationManager()

        let status = CLAuthorizationStatus.notDetermined

        LocationManager.shared.onAuthorizationStatusChange(for: mockLocationManager) {(_) in
            XCTFail()
        }

        mockLocationManager.updateAuthorizationStatus(status)
    }

    func testRequestAlwaysAuthorization() {
        let mockLocationManager = MockLocationManager()

        let requestExpectation = expectation(description: "Request Authorization")
        let status = CLAuthorizationStatus.authorizedAlways

        mockLocationManager.onAuthorizationRequest {(_) in
            return status
        }

        LocationManager.shared.requestAlwaysAuthorization(from: mockLocationManager) {(authorizedStatus) in
            XCTAssert(authorizedStatus == status)
            requestExpectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    func testRequestWhenInUseAuthorization() {
        let mockLocationManager = MockLocationManager()

        let requestExpectation = expectation(description: "Request Authorization")
        let status = CLAuthorizationStatus.authorizedAlways

        mockLocationManager.onAuthorizationRequest {(_) in
            return status
        }

        LocationManager.shared.requestWhenInUseAuthorization(from: mockLocationManager) {(authorizedStatus) in
            XCTAssert(authorizedStatus == status)
            requestExpectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    func testStartLocationUpdates() {
        let mockLocationManager = MockLocationManager()

        let dallas = Location(latitude: 32.7767, longitude: -96.7970)
        let updateExpectation = expectation(description: "Update Location")

        mockLocationManager.onStartLocationUpdatesRequest {
            mockLocationManager.updateLocation(dallas)
        }

        LocationManager.shared.startLocationUpdates(with: mockLocationManager) {(newLocations) in
            guard let newLocation = newLocations.first else {
                XCTFail()
                return
            }

            XCTAssert(newLocation.latitude == dallas.latitude)
            XCTAssert(newLocation.longitude == dallas.longitude)
            updateExpectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    func testStopLocationUpdates() {
        let mockLocationManager = MockLocationManager()
        let endRequestExpectation = expectation(description: "End Location Updates")

        mockLocationManager.onEndLocationUpdatesRequest {
            endRequestExpectation.fulfill()
        }

        LocationManager.shared.stopLocationUpdates(with: mockLocationManager)
        waitForExpectations(timeout: 3)
    }
}
