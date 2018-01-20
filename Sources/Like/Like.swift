//
//  Like.swift
//  Core
//
//  Created by Pranjal Satija on 1/18/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

/// Used to represent the act of liking an event.
class Like: Object {
    @NSManaged var event: Event!
    @NSManaged var user: PFUser!
}

// MARK: Custom Initializer
extension Like {
    convenience init(event: Event, user: PFUser) {
        self.init()
        self.event = event
        self.user = user
    }
}

// MARK: API
extension Like {
    /// Creates and eventually saves a new like with the specified event and user.
    static func create(event: Event, user: PFUser, using api: APIProtocol.Type = ParseAPI.self) {
        let like = Like(event: event, user: user)
        api.saveEventually(like)
    }

    /// Checks whether or not the specifed user has liked the specified event.
    static func exists(user: PFUser,
                       event: Event,
                       using api: APIProtocol.Type,
                       completion: @escaping CompletionHandler<Bool>) {
        let query = baseQuery()
        query.whereKey("event", equalTo: event)
        query.whereKey("user", equalTo: user)
        api.findFirstObject(matching: query) {(error, like) in
            main { completion(error, like != nil) }
        }
    }
}

// MARK: PFSubclassing
extension Like: PFSubclassing {
    static func parseClassName() -> String {
        return "Like"
    }
}
