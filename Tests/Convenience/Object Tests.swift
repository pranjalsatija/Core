//
//  Object Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/16/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import XCTest

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

        let object1 = TestObject(pointerWithObjectID: "foobar")
        let object2 = TestObject(pointerWithObjectID: "foobar")
        XCTAssert(object1 == object2)

        object1["someKey"] = "someOtherValue"
        object2["someKey"] = "someValue"
        XCTAssert(object1 != object2)

        object2.objectId = "foobaz"
        XCTAssert(object1 != object2)
    }

    func testNegativeEquality() {
        //swiftlint:disable:next nesting
        class TestObject: Object, PFSubclassing {
            static func parseClassName() -> String {
                return "TestObject2"
            }
        }

        let object1 = TestObject(pointerWithObjectID: "foobar")
        let object2 = PFObject(withoutDataWithClassName: "SomeObject", objectId: "foobar")
        XCTAssert(object1 != object2)
    }
}
