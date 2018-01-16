//
//  Origin.swift
//  Core
//
//  Created by Pranjal Satija on 1/14/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

/// Used to represent an event's *origin*, or the data source that vended the event.
public enum EventOrigin: String {
    case eventbrite
    case eventful

    init?(_ originString: String?) {
        if let originString = originString, let origin = EventOrigin(rawValue: originString) {
            self = origin
        } else {
            return nil
        }
    }
}

// MARK: Event Extension
extension Event {
    public typealias Origin = EventOrigin
}
