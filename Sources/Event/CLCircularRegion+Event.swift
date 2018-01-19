//
//  CLCircularRegion+Event.swift
//  Core
//
//  Created by Pranjal Satija on 1/14/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import CoreLocation

// MARK: CLCircularRegion Extension
public extension CLCircularRegion {
    convenience init(event: Event, identifier: String? = nil) {
        self.init(
            center: CLLocationCoordinate2D.init(event.location),
            radius: event.radius.doubleValue,
            identifier: (event.objectId ?? identifier)!
        )
    }
}
