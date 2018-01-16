//
//  Referral.swift
//  Core
//
//  Created by Pranjal Satija on 1/13/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

/// Used to represent referrals (when a user opens a link to mark).
class Referral: Object {
    @NSManaged var sender, receiver: PFUser!
    @NSManaged var event: Event!
}

// MARK: Custom Initializer
extension Referral {
    convenience init(sender: PFUser, receiver: PFUser, event: Event) {
        self.init()
        acl = .onlyAccessibleByMasterKey
        self.event = event
        self.sender = sender
        self.receiver = receiver
    }
}

// MARK: API
extension Referral {
    /// Creates and eventually saves a new referral with the given sender and receiver.
    static func create(sender: PFUser, receiver: PFUser, event: Event, api: APIProtocol.Type = ParseAPI.self) {
        let referral = Referral(sender: sender, receiver: receiver, event: event)
        api.saveEventually(referral)
    }
}

// MARK: PFSubclassing
extension Referral: PFSubclassing {
    static func parseClassName() -> String {
        return "Referral"
    }
}
