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

// MARK: Refreshing
public extension Object {
    func refreshInPlace(using api: APIProtocol.Type = ParseAPI.self, completion: @escaping (Swift.Error?) -> Void) {
        guard let objectID = objectId else {
            completion(Error.missingData)
            return
        }

        let query = PFQuery(className: parseClassName)
        query.whereKey("objectId", equalTo: objectID)
        query.includeKeys(allKeys)

        api.findFirstObject(matching: query) {(error, object) in
            if let error = error {
                completion(error)
            } else if let object = object, object.parseClassName == self.parseClassName {
                for key in object.allKeys {
                    self[key] = object[key]
                }

                completion(nil)
            } else {
                completion(Error.unknown)
            }
        }
    }
}

// MARK: Equality
public extension Object {
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? Object else {
            return false
        }

        for key in allKeys where self[key] as? NSObject != object[key] as? NSObject {
            return false
        }

        return true
    }

    convenience init(pointerWithObjectID objectID: String) {
        self.init(withoutDataWithObjectId: objectID)
    }
}
