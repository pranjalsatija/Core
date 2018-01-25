//
//  LocationManagerType.swift
//  Core
//
//  Created by Pranjal Satija on 1/24/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import CoreLocation

public protocol LocationManagerType: class {
    var delegate: CLLocationManagerDelegate? { get set }

    func requestAlwaysAuthorization()
    func requestWhenInUseAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
}
