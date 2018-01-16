//
//  Object Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/16/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import XCTest
@testable import Core

class ObjectTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testEquality() {
        //swiftlint:disable:next nesting
        class TestObject: Object, PFSubclassing {
            static func parseClassName() -> String {
                return "TestObject"
            }
        }

        //swiftlint:disable:next nesting
        class TestObject2: Object, PFSubclassing {
            static func parseClassName() -> String {
                return "TestObject2"
            }
        }

        let object1 = TestObject()
        let object2 = TestObject()
        XCTAssert(object1 == object2)

        object1.objectId = "foobar"
        object2.objectId = "foobar"
        XCTAssert(object1 == object2)

        object2.objectId = "foobaz"
        XCTAssert(object1 != object2)

        let object3 = TestObject2()
        XCTAssert(object1 != object3)
        XCTAssert(object2 != object3)
    }
}
