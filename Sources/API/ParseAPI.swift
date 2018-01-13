//
//  API.swift
//  Core
//
//  Created by Pranjal Satija on 1/12/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

/// An implementation of `APIProtocol` that uses Parse as the backing API.
public struct ParseAPI: APIProtocol {
    public static func findFirstObject<T>(query: PFQuery<T>) throws -> T {
        return try query.getFirstObject()
    }

    public static func findObjects<T>(query: PFQuery<T>) throws -> [T] {
        return try query.findObjects()
    }

    public static func save(_ object: PFObject) throws {
        try object.save()
    }

    public static func saveEventually(_ object: PFObject) {
        object.saveEventually()
    }
}
