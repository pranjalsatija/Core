//
//  Convenience Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/12/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import XCTest
@testable import Core

class ConvenienceTests: XCTestCase {
    func testBackground() {
        let e = expectation(description: "expectation")

        background {
            XCTAssert(!Thread.isMainThread)
            e.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    func testBackgroundWithCompletionHandler() {
        let e = expectation(description: "expectation")

        background({
            //do something
        }, completionHandler: {(error) in
            XCTAssert(error == nil)
            e.fulfill()
        })

        waitForExpectations(timeout: 3)
    }

    func testBackgroundWithCompletionHandlerAndError() {
        //swiftlint:disable:next nesting
        enum TestError: Swift.Error {
            case testError
        }

        let e = expectation(description: "expectation")

        background({
            throw TestError.testError
        }, completionHandler: {(error) in
            guard let error = error as? TestError else {
                XCTFail()
                return
            }

            XCTAssert(error == .testError)
            e.fulfill()
        })

        waitForExpectations(timeout: 3)
    }

    func testMain() {
        let e = expectation(description: "expectation")

        main {
            XCTAssert(Thread.isMainThread)
            e.fulfill()
        }

        waitForExpectations(timeout: 3)
    }
}
