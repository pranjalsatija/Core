//
//  Share.swift
//  Core
//
//  Created by Pranjal Satija on 1/14/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

/// Used to represent shares.
class Share: PFObject {
    @NSManaged private(set) var user: PFUser!
    //TODO: @NSManaged private(set) var event: Event!
}

// MARK: Custom Initializer
extension Share {
    convenience init(user: PFUser) {
        self.init()
        acl = .onlyAccessibleByMasterKey
        self.user = user
    }
}

// MARK: API
extension Share {
    /// Creates and eventually saves a new referral with the given sender and receiver.
    static func create(user: PFUser, api: APIProtocol.Type = ParseAPI.self) {
        let share = Share(user: user)
        api.saveEventually(share)
    }
}

// MARK: PFSubclassing
extension Share: PFSubclassing {
    static func parseClassName() -> String {
        return "Share"
    }
}
