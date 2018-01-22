//
//  User Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/21/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import XCTest

class UserTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testLogOut() {
        let logOutExpectation = expectation(description: "Log Out")
        let user = User()

        user.logOut(using: MockAPI.self) {(_) in
            logOutExpectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

    func testSendPIN() {
        let completionExpectation = expectation(description: "Completion")
        let phoneNumber = "18007726525", testUser = User()

        MockAPI.onFunctionCall {(function, parameters) in
            XCTAssert(function == CloudFunction.beginPhoneNumberAuthentication)
            XCTAssert(parameters?["phoneNumber"] as? String == phoneNumber)
            return testUser
        }

        User.sendPIN(to: phoneNumber, using: MockAPI.self) {(_, user) in
            XCTAssert(user == testUser)
            completionExpectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        MockAPI.cleanUp()
    }

    func testSendPINWithInvalidPhoneNumber() {
        let completionExpectation = expectation(description: "Completion")
        let phoneNumber = "18007726525"

        MockAPI.onFunctionCall {(function, parameters) in
            XCTAssert(function == CloudFunction.beginPhoneNumberAuthentication)
            XCTAssert(parameters?["phoneNumber"] as? String == phoneNumber)
            throw User.Error.invalidPhoneNumber
        }

        User.sendPIN(to: phoneNumber, using: MockAPI.self) {(error, _) in
            guard let error = error as? User.Error else {
                XCTFail()
                return
            }

            XCTAssert(error == .invalidPhoneNumber)
            completionExpectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        MockAPI.cleanUp()
    }

    func testVerifyPIN() {
        let completionExpectation = expectation(description: "Completion")
        let pin = "12345", testUser = User()
        testUser.username = "testUser"

        MockAPI.onLogIn {(username, password) in
            XCTAssert(username == testUser.username)
            XCTAssert(password == pin)
            return testUser
        }

        testUser.verifyPIN(pin, using: MockAPI.self) {(_, authenticated) in
            XCTAssert(authenticated == true)
            completionExpectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        MockAPI.cleanUp()
    }

    func testVerifyPINWithIncorrectPIN() {
        let completionExpectation = expectation(description: "Completion")
        let pin = "12345", testUser = User()
        testUser.username = "testUser"

        MockAPI.onLogIn {(username, password) in
            XCTAssert(username == testUser.username)
            XCTAssert(password == pin)
            throw User.Error.invalidPIN
        }

        testUser.verifyPIN(pin, using: MockAPI.self) {(error, _) in
            guard let error = error as? User.Error else {
                XCTFail()
                return
            }

            XCTAssert(error == .invalidPIN)
            completionExpectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        MockAPI.cleanUp()
    }

    func testVerifyPINWithMissingUsername() {
        let completionExpectation = expectation(description: "Completion")
        let pin = "12345", testUser = User()

        MockAPI.onLogIn {(_, _) in
            XCTFail()
            throw Core.Error.unknown
        }

        testUser.verifyPIN(pin, using: MockAPI.self) {(error, _) in
            guard let error = error as? Core.Error else {
                XCTFail()
                return
            }

            XCTAssert(error == .missingData)
            completionExpectation.fulfill()
        }

        waitForExpectations(timeout: 3)
        MockAPI.cleanUp()
    }
}
