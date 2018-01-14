//
//  Referral.swift
//  Core
//
//  Created by Pranjal Satija on 1/13/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

/// Used to represent referrals (when a user opens a link to mark).
class Referral: PFObject {
    @NSManaged private(set) var sender, receiver: PFUser!
    //TODO: @NSManaged private(set) var event: Event!
}

// MARK: Custom Initializer
extension Referral {
    convenience init(sender: PFUser, receiver: PFUser) {
        self.init()
        acl = .onlyAccessibleByMasterKey
        self.sender = sender
        self.receiver = receiver
    }
}

// MARK: API
extension Referral {
    /// Creates and eventually saves a new referral with the given sender and receiver.
    static func create(sender: PFUser, receiver: PFUser, api: APIProtocol.Type = ParseAPI.self) {
        let referral = Referral(sender: sender, receiver: receiver)
        api.saveEventually(referral)
    }
}

// MARK: PFSubclassing
extension Referral: PFSubclassing {
    static func parseClassName() -> String {
        return "Referral"
    }
}
