//
//  Location.swift
//  Core
//
//  Created by Pranjal Satija on 1/14/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

/// A protocol that can be used to represent various location types.
public protocol LocationType {
    var latitude: Double { get }
    var longitude: Double { get }

    init(latitude: Double, longitude: Double)

    func distance(from otherLocation: LocationType) -> Double
}

// MARK: Default Implementation
public extension LocationType {
    func distance(from otherLocation: LocationType) -> Double {
        return CLLocation(otherLocation).distance(from: CLLocation(self))
    }
}
