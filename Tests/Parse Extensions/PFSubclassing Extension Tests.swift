//
//  PFSubclassing Extension Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/13/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import XCTest
@testable import Core

class PFSubclassingExtensionTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testPFSubclassingExtension() {
        //swiftlint:disable:next nesting
        class SomeSubclass: PFObject, PFSubclassing {
            static func parseClassName() -> String {
                return "SomeSubclass"
            }
        }

        let query = SomeSubclass.baseQuery()
        XCTAssert(query.parseClassName == SomeSubclass.parseClassName())
    }
}
