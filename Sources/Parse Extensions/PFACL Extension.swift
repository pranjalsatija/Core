//
//  PFACL Extension.swift
//  Core
//
//  Created by Pranjal Satija on 1/11/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

extension PFACL {
    /// Creates an ACL that only grants read and write access to a specific user.
    /// Read and write access for all other users is denied.
    static func onlyAccessible(to user: PFUser) -> PFACL {
        let acl = PFACL()
        acl.setReadAccess(true, for: user)
        acl.setWriteAccess(true, for: user)
        return acl
    }

    /// Creates an ACL that only grants read and write access to the master key.
    /// Read and write access for all users is denied.
    static var onlyAccessibleByMasterKey: PFACL {
        let acl = PFACL()
        acl.getPublicWriteAccess = false
        acl.getPublicReadAccess = false
        return acl
    }
}
