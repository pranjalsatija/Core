//
//  PFUser+Referral.swift
//  Core
//
//  Created by Pranjal Satija on 1/13/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

// MARK: PFUser Extension
extension PFUser {
    /// Registers that a specified user referred this user to an event on mark.
    public func registerReferral(from user: PFUser, api: APIProtocol.Type = ParseAPI.self) {
        Referral.create(sender: user, receiver: self, api: api)
    }
}
