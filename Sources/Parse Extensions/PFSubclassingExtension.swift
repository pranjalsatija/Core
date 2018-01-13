//
//  PFSubclassingExtension.swift
//  Core
//
//  Created by Pranjal Satija on 1/12/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

extension PFSubclassing where Self: PFObject {
    /// Creates an empty generic query for this PFObject subclass.
    /// The query is properly configured to use the appropriate Parse class name,
    /// and is ready for additional constraints.
    static func baseQuery() -> PFQuery<Self> {
        return PFQuery<Self>(className: parseClassName())
    }
}
