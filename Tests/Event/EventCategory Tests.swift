//
//  EventCategory Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/16/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import XCTest

class EventCategoryTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testGetIconImage() {
        let downloadExpectation = expectation(description: "Download")
        let bundle = Bundle(for: EventCategoryTests.self)
        let bundleImage = UIImage(named: "testImage.jpg", in: bundle, compatibleWith: nil)
        guard let image = bundleImage, let imageData = UIImageJPEGRepresentation(image, 1.0) else {
            XCTFail()
            return
        }

        let category = Event.Category()
        category.iconFile = PFFile(data: imageData)
        category.iconFileScaleFactor = 2.0

        MockAPI.onFileDownload {(_) in
            return imageData
        }

        category.getIconImage(from: MockAPI.self) {(_, loadedImage) in
            XCTAssert(loadedImage != nil)
            XCTAssert(Thread.isMainThread)
            downloadExpectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    func testGetIconImageWithError() {
        let downloadExpectation = expectation(description: "Download")

        //swiftlint:disable:next nesting
        enum TestError: Swift.Error {
            case error
        }

        let data = Data()
        let category = Event.Category()
        category.iconFile = PFFile(data: data)

        MockAPI.onFileDownload {(_) in
            throw TestError.error
        }

        category.getIconImage(from: MockAPI.self) {(error, _) in
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

    func testGetIconImageWithInvalidImage() {
        let downloadExpectation = expectation(description: "Download")
        let data = Data()
        let category = Event.Category()
        category.iconFile = PFFile(data: data)

        MockAPI.onFileDownload {(_) in
            return data
        }

        category.getIconImage(from: MockAPI.self) {(error, _) in
            guard let error = error as? Core.Error else {
                XCTFail()
                return
            }

            XCTAssert(error == .invalidResponseFormat)
            XCTAssert(Thread.isMainThread)
            downloadExpectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }
}
