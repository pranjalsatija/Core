//
//  PFUser+NotificationOpen.swift
//  Core
//
//  Created by Pranjal Satija on 1/13/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

// MARK: PFUser Extension
public extension PFUser {
    /// Registers the fact that this user opened the specified notification.
    func registerNotificationOpen(userInfo: [String: Any], api: APIProtocol.Type = ParseAPI.self) {
        NotificationOpen.create(with: self, userInfo: userInfo, api: api)
    }
}
