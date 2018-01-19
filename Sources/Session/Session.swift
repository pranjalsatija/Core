//
//  Session.swift
//  Core
//
//  Created by Pranjal Satija on 1/11/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

/// Used to represent individual usage sessions.
class Session: Object {
    @NSManaged var startDate, endDate: Date!
    @NSManaged var user: PFUser!
}

// MARK: Custom Initializer
extension Session {
    convenience init(user: PFUser, startDate: Date) {
        self.init()
        acl = .onlyAccessibleByMasterKey
        self.startDate = startDate
        self.user = user
    }
}

// MARK: API
extension Session {
    /// Creates and eventually saves a new session belonging to the specified user.
    static func create(with user: PFUser, api: APIProtocol.Type = ParseAPI.self) {
        let session = Session(user: user, startDate: Date())
        api.saveEventually(session)
    }

    /// Ends the latest session belonging to the specified user.
    static func endLatest(belongingTo user: PFUser, api: APIProtocol.Type = ParseAPI.self) {
        let query = baseQuery()
        query.whereKey("user", equalTo: user)
        query.whereKeyDoesNotExist("endDate")
        query.addDescendingOrder("startDate")
        api.findFirstObject(matching: query) {(_, session) in
            guard let session = session else {
                return
            }

            session.endDate = Date()
            api.saveEventually(session)
        }
    }
}

// MARK: PFSubclassing
extension Session: PFSubclassing {
    static func parseClassName() -> String {
        return "UsageSession"
    }
}
