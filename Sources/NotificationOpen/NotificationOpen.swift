//
//  NotificationOpen.swift
//  Core
//
//  Created by Pranjal Satija on 1/13/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

/// Used to represent the fact that the user opened a notification.
class NotificationOpen: PFObject {
    @NSManaged private(set) var category: String!
    //TODO: @NSManaged private(set) var event: Event!
    @NSManaged private(set) var user: PFUser!
}

// MARK: Custom Initializer
extension NotificationOpen {
    /// Creates a new `NotificationOpen` object from the `userInfo` of a local or remote notification.
    /// - parameter user: The user that opened the notification.
    /// - parameter userInfo: The `userInfo` dictionary from the notification.
    convenience init(user: PFUser, userInfo: [String: Any]) {
        self.init()

        // Push notifications store the relevant data in the nested aps key.
        // If that key is present, we use it to query the notification's info.
        let notificationInfo = userInfo["aps"] as? [String: Any] ?? userInfo

        /*if let eventID = notificationInfo["event"] as? String {
            event = Event(pointerWithObjectID: eventID)
        }*/

        acl = .onlyAccessibleByMasterKey
        category = notificationInfo["category"] as? String
        //event = Event(pointerWithObjectID: eventID)
        self.user = user
    }
}

// MARK: API
extension NotificationOpen {
    /// Creates and eventually saves a new notification open object with the specified information.
    static func create(with user: PFUser, userInfo: [String: Any], api: APIProtocol.Type = ParseAPI.self) {
        let notificationOpen = NotificationOpen(user: user, userInfo: userInfo)
        api.saveEventually(notificationOpen)
    }
}

// MARK: PFSubclassing
extension NotificationOpen: PFSubclassing {
    static func parseClassName() -> String {
        return "NotificationOpen"
    }
}
