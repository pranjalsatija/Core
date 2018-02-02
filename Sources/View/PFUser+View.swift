//
//  PFUser+View.swift
//  Core
//
//  Created by Pranjal Satija on 1/21/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

public extension PFUser {
    func markAsViewed(_ event: Event, using api: APIProtocol.Type = ParseAPI.self) {
        View.create(withEvent: event, user: self, using: api)
    }
}
