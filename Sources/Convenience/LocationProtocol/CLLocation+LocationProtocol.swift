//
//  CLLocation Extension.swift
//  Core
//
//  Created by Pranjal Satija on 1/14/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import CoreLocation

// MARK: CLLocation Extension
extension CLLocation: LocationProtocol {
    public var latitude: Double {
        return coordinate.latitude
    }

    public var longitude: Double {
        return coordinate.longitude
    }

    public convenience init(_ location: LocationProtocol) {
        self.init(latitude: location.latitude, longitude: location.longitude)
    }
}
