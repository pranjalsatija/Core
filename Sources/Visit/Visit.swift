//
//  Visit.swift
//  Core
//
//  Created by Pranjal Satija on 1/21/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

/// Used to represent a user visiting an event on mark.
public class Visit: Object {
    @NSManaged public var event: Event!
    @NSManaged public var user: PFUser!
}

// MARK: Custom Initializer
extension Visit {
    convenience init(event: Event, user: PFUser) {
        self.init()
        self.event = event
        self.user = user
    }
}

// MARK: API
extension Visit {
    static func create(with event: Event, user: PFUser, using api: APIProtocol.Type = ParseAPI.self) {
        let visit = Visit(event: event, user: user)
        api.saveEventually(visit)
    }

    static func getVisits(forUser user: User,
                          using api: APIProtocol.Type = ParseAPI.self,
                          completion: @escaping CompletionHandler<[Visit]>) {

        let query = baseQuery()
        query.whereKey("user", equalTo: user)
        query.includeKey("event")
        query.includeKey("event.category")
        query.addDescendingOrder("createdAt")
        api.findObjects(matching: query) {(error, visits) in
            main { completion(error, visits) }
        }
    }
}

// MARK: PFSubclassing
extension Visit: PFSubclassing {
    public static func parseClassName() -> String {
        return "Visit"
    }
}
