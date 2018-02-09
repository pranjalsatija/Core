//
//  Collection Extension.swift
//  Core
//
//  Created by Pranjal Satija on 2/9/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import Foundation

public extension Collection {
    func forAll(_ condition: (Element) throws -> Bool) rethrows -> Bool {
        return try first { try !condition($0) } == nil
    }
}
