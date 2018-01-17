//
//  GeoBox.swift
//  Core
//
//  Created by Pranjal Satija on 1/16/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

/// A protocol used to represent types that can be used for geospatial queries.
public protocol GeoBox {
    var northeast: LocationProtocol { get }
    var southwest: LocationProtocol { get }
}
