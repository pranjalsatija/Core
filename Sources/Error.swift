//
//  Error.swift
//  Core
//
//  Created by Pranjal Satija on 1/11/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

/// A general purpose error enumeration.
public enum Error: Swift.Error {
    case missingData(description: String?)
    case unknown
}
