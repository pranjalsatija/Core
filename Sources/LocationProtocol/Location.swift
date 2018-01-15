//
//  Location.swift
//  Core
//
//  Created by Pranjal Satija on 1/14/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

public struct Location: LocationProtocol {
    public let latitude, longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    public init(_ location: LocationProtocol) {
        self = Location(latitude: location.latitude, longitude: location.longitude)
    }
}
