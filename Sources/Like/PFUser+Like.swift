//
//  PFUser+Like.swift
//  Core
//
//  Created by Pranjal Satija on 1/18/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

extension PFUser {
    /// Registers that this user liked a specified event.
    public func like(event: Event, api: APIProtocol.Type = ParseAPI.self) {
        Like.create(event: event, user: self, api: api)
    }

    /// Checks if this user has liked a specified event.
    public func hasLiked(event: Event,
                         api: APIProtocol.Type = ParseAPI.self,
                         completion: @escaping CompletionHandler<Bool>) {
        Like.exists(user: self, event: event, api: api, completion: completion)
    }
}
