//
//  PFUser+Like.swift
//  Core
//
//  Created by Pranjal Satija on 1/18/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

public extension PFUser {
    /// Registers that this user liked a specified event.
    func like(event: Event, api: APIProtocol.Type = ParseAPI.self, completion: CompletionHandler<Bool>? = nil) {
        Like.create(event: event, user: self, using: api, completion: completion)
    }

    /// Checks if this user has liked a specified event.
    func hasLiked(event: Event,
                  api: APIProtocol.Type = ParseAPI.self,
                  completion: @escaping CompletionHandler<Bool>) {
        Like.exists(user: self, event: event, using: api, completion: completion)
    }
}
