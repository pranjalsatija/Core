//
//  API.swift
//  Core
//
//  Created by Pranjal Satija on 1/12/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

/// An implementation of `APIProtocol` that uses Parse as the backing API.
public struct ParseAPI: APIProtocol {
    public static func call(_ function: CloudFunction, parameters: [AnyHashable : Any]?) throws -> Any {
        return try PFCloud.callFunction(function.name, withParameters: parameters)
    }

    public static func findFirstObject<T>(matching query: PFQuery<T>) throws -> T {
        return try query.getFirstObject()
    }

    public static func findObjects<T>(matching query: PFQuery<T>) throws -> [T] {
        return try query.findObjects()
    }

    public static func getData(from file: PFFile) throws -> Data {
        return try file.getData()
    }

    public static func getObject<T: PFObject>(objectID: String) throws -> T {
        guard let query = T.query() as? PFQuery<T> else { throw Error.missingData }
        query.whereKey("objectId", equalTo: objectID)
        return try findFirstObject(matching: query)
    }

    public static func logIn(withUsername username: String, password: String) throws -> PFUser {
        return try PFUser.logIn(withUsername: username, password: password)
    }

    public static func logOut() {
        return User.logOut()
    }

    public static func save(_ object: PFObject) throws {
        try object.save()
    }

    public static func saveEventually(_ object: PFObject) {
        object.saveEventually()
    }
}
