//
//  Event Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/16/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import XCTest

class EventTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testDuration() {
        let event = Event(), now = Date()
        event.startDate = now
        event.endDate = now.addingTimeInterval(2.hours)
        XCTAssert(event.duration == 2.hours)
    }

    func testGetCoverPhotoSuccessfully() {
        let downloadExpectation = expectation(description: "Download")
        let bundle = Bundle(for: EventCategoryTests.self)
        let bundleImage = UIImage(named: "testImage.jpg", in: bundle, compatibleWith: nil)
        guard let image = bundleImage, let imageData = UIImageJPEGRepresentation(image, 1.0) else {
            XCTFail()
            return
        }

        let event = Event()
        event.coverPhoto = PFFile(data: imageData)

        MockAPI.onFileDownload {(_) in
            return imageData
        }

        event.getCoverPhoto(from: MockAPI.self) {(_, coverPhoto) in
            XCTAssert(coverPhoto?.size == image.size)
            XCTAssert(Thread.isMainThread)
            downloadExpectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    func testGetCoverPhotoWithFailedImageLoad() {
        let downloadExpectation = expectation(description: "Download")
        let bundle = Bundle(for: EventCategoryTests.self)
        let bundleImage = UIImage(named: "testImage.jpg", in: bundle, compatibleWith: nil)
        guard let image = bundleImage, let imageData = UIImageJPEGRepresentation(image, 1.0) else {
            XCTFail()
            return
        }

        let event = Event()
        event.coverPhoto = PFFile(data: imageData)

        //swiftlint:disable:next nesting
        enum TestError: Swift.Error {
            case error
        }

        MockAPI.onFileDownload {(_) in
            throw TestError.error
        }

        event.getCoverPhoto(from: MockAPI.self) {(error, _) in
            guard let error = error as? TestError else {
                XCTFail()
                return
            }

            XCTAssert(error == .error)
            XCTAssert(Thread.isMainThread)
            downloadExpectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    func testGetCoverPhotoWithNoCoverPhoto() {
        let downloadExpectation = expectation(description: "Download")
        let bundle = Bundle(for: EventCategoryTests.self)
        let bundleImage = UIImage(named: "testImage.jpg", in: bundle, compatibleWith: nil)
        guard let image = bundleImage, let imageData = UIImageJPEGRepresentation(image, 1.0) else {
            XCTFail()
            return
        }

        let event = Event()

        MockAPI.onFileDownload {(_) in
            return imageData
        }

        event.getCoverPhoto(from: MockAPI.self) {(error, _) in
            guard let error = error as? Core.Error else {
                XCTFail()
                return
            }

            XCTAssert(error == .missingData)
            XCTAssert(Thread.isMainThread)
            downloadExpectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    func testGetCurrentlyOccurringEventsNearLocation() {
        let queryExpectation = expectation(description: "Query")
        let dallas = Location(latitude: 32.7767, longitude: -96.7970)

        let testEvents = [
            Event(pointerWithObjectID: "testEvent1"),
            Event(pointerWithObjectID: "testEvent2"),
            Event(pointerWithObjectID: "testEvent3")
        ]

        MockAPI.onQuery {(_) in
            return testEvents
        }

        Event.getCurrentlyOccurringEvents(near: dallas, maxDistance: 50, from: MockAPI.self) {(_, events) in
            guard let events = events else {
                XCTFail()
                return
            }

            XCTAssert(events == testEvents)
            XCTAssert(Thread.isMainThread)
            queryExpectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    func testGetRelevantEventsInBox() {
        let queryExpectation = expectation(description: "Query")

        //swiftlint:disable:next nesting
        struct Box: GeoBox {
            let northeast: LocationType, southwest: LocationType
        }

        let dallas = Location(latitude: 32.7767, longitude: -96.7970)
        let northeast = Location(latitude: dallas.latitude * 1.1, longitude: dallas.longitude * 1.1)
        let southwest = Location(latitude: dallas.latitude * 0.9, longitude: dallas.longitude * 0.9)
        let box = Box(northeast: northeast, southwest: southwest)

        let testEvents = [
            Event(pointerWithObjectID: "testEvent1"),
            Event(pointerWithObjectID: "testEvent2"),
            Event(pointerWithObjectID: "testEvent3")
        ]

        MockAPI.onQuery {(_) in
            return testEvents
        }

        Event.getRelevantEvents(in: box, categories: [], from: MockAPI.self) {(_, events) in
            guard let events = events else {
                XCTFail()
                return
            }

            XCTAssert(events == testEvents)
            XCTAssert(Thread.isMainThread)
            queryExpectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    func testGetRelevantEventsInBoxWithError() {
        let queryExpectation = expectation(description: "Query")

        //swiftlint:disable:next nesting
        struct Box: GeoBox {
            let northeast: LocationType, southwest: LocationType
        }

        //swiftlint:disable:next nesting
        enum TestError: Swift.Error {
            case testError
        }

        let dallas = Location(latitude: 32.7767, longitude: -96.7970)
        let northeast = Location(latitude: dallas.latitude * 1.1, longitude: dallas.longitude * 1.1)
        let southwest = Location(latitude: dallas.latitude * 0.9, longitude: dallas.longitude * 0.9)
        let box = Box(northeast: northeast, southwest: southwest)

        MockAPI.onQuery {(_) in
            throw TestError.testError
        }

        Event.getRelevantEvents(in: box, categories: [], from: MockAPI.self) {(error, _) in
            guard let error = error as? TestError else {
                XCTFail()
                return
            }

            XCTAssert(error == .testError)
            XCTAssert(Thread.isMainThread)
            queryExpectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    func testIsCurrentlyOccurring() {
        let event = Event(), now = Date()
        event.startDate = now.addingTimeInterval(-30.minutes)
        event.endDate = now.addingTimeInterval(30.minutes)
        XCTAssert(event.isCurrentlyOccurring)

        event.endDate = now.addingTimeInterval(-15.minutes)
        XCTAssert(!event.isCurrentlyOccurring)
    }

    func testIsEndingSoon() {
        let event = Event(), now = Date()
        event.startDate = now.addingTimeInterval(-3.hours)
        event.endDate = now.addingTimeInterval(15.minutes)
        XCTAssert(event.isEndingSoon)

        event.endDate = now.addingTimeInterval(2.hours)
        XCTAssert(!event.isEndingSoon)
    }

    func testOrigin() {
        let event = Event()
        event["origin"] = Event.Origin.eventbrite.rawValue
        XCTAssert(event.origin == .eventbrite)

        event["origin"] = Event.Origin.eventful.rawValue
        XCTAssert(event.origin == .eventful)

        event["origin"] = "testOrigin"
        XCTAssert(event.origin == nil)
    }

    func testOriginURL() {
        let event = Event(), originURL = "https://api.mark.events/someOrigin"
        event["originURL"] = originURL
        XCTAssert(event.originURL?.absoluteString == originURL)

        event["originURL"] = NSNull()
        XCTAssert(event.originURL == nil)
    }

    func testUserIsPresent() {
        let dallas = Location(latitude: 32.7767, longitude: -96.7970)

        let event = Event()
        event.location = PFGeoPoint(dallas)
        event.radius = 500

        let user = User()
        user.location = Portal(name: "userLocationPortal")
        user.location.update(dallas)

        XCTAssert(event.userIsPresent(user))
    }

    func testUserIsPresentWithoutLocation() {
        let dallas = Location(latitude: 32.7767, longitude: -96.7970)

        let event = Event()
        event.location = PFGeoPoint(dallas)
        event.radius = 500

        let user = User()
        XCTAssert(!event.userIsPresent(user))
    }
}
