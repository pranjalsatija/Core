//
//  CLLocationCoordinate2D Extension.swift
//  Core
//
//  Created by Pranjal Satija on 1/14/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import CoreLocation

// MARK: CLLocationCoordinate2D Extension
extension CLLocationCoordinate2D: LocationType {
    public init(_ location: LocationType) {
        self.init(latitude: location.latitude, longitude: location.longitude)
    }
}
