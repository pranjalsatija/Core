//
//  View.swift
//  Core
//
//  Created by Pranjal Satija on 1/21/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

/// Used to represent a user viewing an event on mark.
class View: Object {
    @NSManaged var event: Event!
    @NSManaged var user: PFUser!
}

// MARK: Custom Initializer
extension View {
    convenience init(event: Event, user: PFUser) {
        self.init()
        self.event = event
        self.user = user
    }
}

// MARK: API
extension View {
    static func create(withEvent event: Event, user: PFUser, using api: APIProtocol.Type = ParseAPI.self) {
        let view = View(event: event, user: user)
        api.saveEventually(view)
    }
}

// MARK: PFSubclassing
extension View: PFSubclassing {
    static func parseClassName() -> String {
        return "View"
    }
}
