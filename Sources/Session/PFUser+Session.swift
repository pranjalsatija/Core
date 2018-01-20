//
//  PFUser+Session.swift
//  Core
//
//  Created by Pranjal Satija on 1/11/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

// MARK: PFUser Extension
public extension PFUser {
    /// Starts a session and assigns it to this user.
    func startSession(using api: APIProtocol.Type = ParseAPI.self) {
        Session.create(with: self, using: api)
    }

    /// Ends the latest session belonging to this user.
    func endLatestSession(using api: APIProtocol.Type = ParseAPI.self) {
        Session.endLatest(belongingTo: self, using: api)
    }
}
