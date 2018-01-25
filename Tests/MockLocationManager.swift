//
//  MockLocationManager.swift
//  CoreTests
//
//  Created by Pranjal Satija on 1/24/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core

class MockLocationManager {
    weak var delegate: CLLocationManagerDelegate?

    typealias AuthorizationRequestHandler = (AuthorizationType) -> (CLAuthorizationStatus)
    typealias StartLocationUpdatesRequestHandler = () -> Void
    typealias EndLocationUpdatesRequestHandler = () -> Void

    private var authorizationRequestHandler: AuthorizationRequestHandler?
    private var startLocationUpdatesRequestHandler: StartLocationUpdatesRequestHandler?
    private var endLocationUpdatesRequestHandler: EndLocationUpdatesRequestHandler?

    private let dummyCLLocationManager = CLLocationManager()
}

extension MockLocationManager {
    func onAuthorizationRequest(_ block: @escaping AuthorizationRequestHandler) {
        authorizationRequestHandler = block
    }

    func onStartLocationUpdatesRequest(_ block: @escaping StartLocationUpdatesRequestHandler) {
        startLocationUpdatesRequestHandler = block
    }

    func onEndLocationUpdatesRequest(_ block: @escaping EndLocationUpdatesRequestHandler) {
        endLocationUpdatesRequestHandler = block
    }
}

extension MockLocationManager {
    func updateAuthorizationStatus(_ status: CLAuthorizationStatus) {
        delegate?.locationManager?(dummyCLLocationManager, didChangeAuthorization: status)
    }

    func updateLocation(_ location: LocationType) {
        delegate?.locationManager?(dummyCLLocationManager, didUpdateLocations: [CLLocation(location)])
    }
}

extension MockLocationManager: LocationManagerType {
    func requestAlwaysAuthorization() {
        guard let status = authorizationRequestHandler?(.always) else {
            return
        }

        delegate?.locationManager?(dummyCLLocationManager, didChangeAuthorization: status)
    }

    func requestWhenInUseAuthorization() {
        guard let status = authorizationRequestHandler?(.whenInUse) else {
            return
        }

        delegate?.locationManager?(dummyCLLocationManager, didChangeAuthorization: status)
    }

    func startUpdatingLocation() {
        startLocationUpdatesRequestHandler?()
    }

    func stopUpdatingLocation() {
        endLocationUpdatesRequestHandler?()
    }
}

extension MockLocationManager {
    enum AuthorizationType {
        case always
        case whenInUse
    }
}
