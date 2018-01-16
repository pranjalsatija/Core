//
//  PFUser+Share.swift
//  Core
//
//  Created by Pranjal Satija on 1/14/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

// MARK: PFUser Extension
extension PFUser {
    /// Registers that this user shared an event.
    public func registerShare(with event: Event, api: APIProtocol.Type = ParseAPI.self) {
        Share.create(user: self, event: event, api: api)
    }
}
