//
//  PFUser+Referral.swift
//  Core
//
//  Created by Pranjal Satija on 1/13/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

// MARK: PFUser Extension
public extension PFUser {
    /// Registers that a specified user referred this user to an event on mark.
    func registerReferral(from user: PFUser, with event: Event, using api: APIProtocol.Type = ParseAPI.self) {
        Referral.create(sender: user, receiver: self, event: event, using: api)
    }
}
