//
//  Report.swift
//  Core
//
//  Created by Pranjal Satija on 1/20/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

/// Used to allow users to report events on mark.
public class Report: Object {
    @NSManaged var event: Event!
    @NSManaged var reason: String!
    @NSManaged var user: PFUser!
}

// MARK: Custom Initializer
extension Report {
    convenience init(event: Event, reason: Reason, user: PFUser) {
        self.init()
        self.event = event
        self.reason = reason.rawValue
        self.user = user
    }
}

// MARK: API
extension Report {
    static func create(withEvent event: Event, reason: Reason, user: PFUser, using api: APIProtocol.Type) {
        let report = Report(event: event, reason: reason, user: user)
        api.saveEventually(report)
    }
}

// MARK: PFSubclassing
extension Report: PFSubclassing {
    public static func parseClassName() -> String {
        return "Report"
    }
}
