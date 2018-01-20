//
//  PFUser+Report.swift
//  Core
//
//  Created by Pranjal Satija on 1/20/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

// MARK: PFUser Extension
public extension PFUser {
    /// Reports a specified event.
    func report(_ event: Event, reason: Report.Reason, using api: APIProtocol.Type = ParseAPI.self) {
        Report.create(withEvent: event, reason: reason, user: self, using: api)
    }
}
