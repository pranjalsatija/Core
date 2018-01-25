//
//  LocationManager.swift
//  Core
//
//  Created by Pranjal Satija on 1/24/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import CoreLocation

/// Used to access the user's location.
public class LocationManager: NSObject {
    static let shared = LocationManager()
    static public let sharedClLocationManager = CLLocationManager()


    public typealias AuthorizationStatusChangeBlock = (CLAuthorizationStatus) -> Void
    private var authorizationStatusChangeBlock: AuthorizationStatusChangeBlock?

    public typealias LocationUpdateBlock = ([LocationType]) -> Void
    private var locationUpdateBlocks = [LocationUpdateBlock]()
}

// MARK: Authorization
public extension LocationManager {
    func onAuthorizationStatusChange(for locationManager: LocationManagerType = sharedClLocationManager,
                                     _ block: @escaping AuthorizationStatusChangeBlock) {

        locationManager.delegate = self
        authorizationStatusChangeBlock = block
    }

    func requestAlwaysAuthorization(from locationManager: LocationManagerType = sharedClLocationManager,
                                    completion: @escaping (CLAuthorizationStatus) -> Void) {

        locationManager.delegate = self
        authorizationStatusChangeBlock = completion
        locationManager.requestAlwaysAuthorization()
    }

    func requestWhenInUseAuthorization(from locationManager: LocationManagerType = sharedClLocationManager,
                                       completion: @escaping (CLAuthorizationStatus) -> Void) {

        locationManager.delegate = self
        authorizationStatusChangeBlock = completion
        locationManager.requestWhenInUseAuthorization()
    }
}

// MARK: Location Updates
public extension LocationManager {
    func startLocationUpdates(with locationManager: LocationManagerType = sharedClLocationManager,
                              handler: @escaping LocationUpdateBlock) {

        locationManager.delegate = self
        locationUpdateBlocks.append(handler)
        locationManager.startUpdatingLocation()
    }

    func stopLocationUpdates(with locationManager: LocationManagerType = sharedClLocationManager) {
        locationManager.stopUpdatingLocation()
    }
}

// MARK: CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatusChangeBlock?(status)
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationUpdateBlocks.forEach { $0(locations) }
    }
}
