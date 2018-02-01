//
//  URL Extension.swift
//  Core
//
//  Created by Pranjal Satija on 1/31/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

extension URL {
    static func mapsURL(for event: Event) -> URL? {
        guard let location = event.location else {
            return nil
        }

        return URL(string: "http://maps.apple.com/?daddr=\(location.latitude),\(location.longitude)")
    }

    static func shareURL(for event: Event) -> URL? {
        guard let eventID = event.objectId, let userID = User.current.objectId else {
            return nil
        }

        return URL(string: "https://api.mark.events/share?event=\(eventID)&ref=\(userID)")!
    }
}
