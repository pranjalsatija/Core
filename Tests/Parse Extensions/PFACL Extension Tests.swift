//
//  PFACL Extension Tests.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/13/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import XCTest
@testable import Core

class PFACLExtensionTests: XCTestCase {
    override func setUp() {
        performSetupIfNeeded()
    }

    func testOnlyAccessibleToUser() {
        let user = PFUser()
        user.objectId = "abcxyz"

        let acl = PFACL.onlyAccessible(to: user)
        XCTAssert(acl.getPublicReadAccess == false)
        XCTAssert(acl.getPublicWriteAccess == false)
        XCTAssert(acl.getReadAccess(for: user) == true)
        XCTAssert(acl.getWriteAccess(for: user) == true)
    }

    func testOnlyAccessibleByMasterKey() {
        let acl = PFACL.onlyAccessibleByMasterKey
        XCTAssert(acl.getPublicWriteAccess == false)
        XCTAssert(acl.getPublicReadAccess == false)
    }
}
