//
//  PFGeoPoint Extension.swift
//  Core
//
//  Created by Pranjal Satija on 1/14/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import Parse

// MARK: PFGeoPoint Extension
extension PFGeoPoint: LocationType {
    public convenience init(_ location: LocationType) {
        self.init(latitude: location.latitude, longitude: location.longitude)
    }
}
