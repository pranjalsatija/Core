//
//  Object.swift
//  Core
//
//  Created by Pranjal Satija on 1/16/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

/// A common subclass of `PFObject` that provides better support for equality.
/// All instances of `Object` are considered equal if they have the same `objectId` property.
public class Object: PFObject { }

// MARK: Equality
public extension Object {
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? Object else {
            return false
        }

        return object.objectId == self.objectId
    }

    convenience init(pointerWithObjectID objectID: String) {
        self.init(withoutDataWithObjectId: objectID)
    }
}
