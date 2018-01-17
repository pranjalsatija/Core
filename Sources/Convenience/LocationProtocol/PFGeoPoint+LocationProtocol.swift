//
//  PFGeoPoint Extension.swift
//  Core
//
//  Created by Pranjal Satija on 1/14/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

// MARK: PFGeoPoint Extension
extension PFGeoPoint: LocationProtocol {
    public convenience init(_ location: LocationProtocol) {
        self.init(latitude: location.latitude, longitude: location.longitude)
    }
}
