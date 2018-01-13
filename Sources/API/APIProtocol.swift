//
//  APIProtocol.swift
//  Core
//
//  Created by Pranjal Satija on 1/12/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

/// Defines a set of functionality for an API that can be used to save and query data in mark.
public protocol APIProtocol {
    // MARK: Synchronous Methods
    static func findFirstObject<T>(query: PFQuery<T>) throws -> T
    static func findObjects<T>(query: PFQuery<T>) throws -> [T]
    static func save(_ object: PFObject) throws
    static func saveEventually(_ object: PFObject)

    // MARK: Asynchronous Methods
    static func findFirstObject<T>(query: PFQuery<T>, completion: @escaping (Swift.Error?, T?) -> Void)
    static func findObjects<T>(query: PFQuery<T>, completion: @escaping (Swift.Error?, [T]?) -> Void)
    static func save(_ object: PFObject, completion: @escaping (Swift.Error?) -> Void)
}

// MARK: Asynchronous Default Implementations
extension APIProtocol {
    public static func findFirstObject<T>(query: PFQuery<T>, completion: @escaping (Swift.Error?, T?) -> Void) {
        background {
            do {
                try completion(nil, findFirstObject(query: query))
            } catch {
                completion(error, nil)
            }
        }
    }

    public static func findObjects<T>(query: PFQuery<T>, completion: @escaping (Swift.Error?, [T]?) -> Void) {
        background {
            do {
                try completion(nil, findObjects(query: query))
            } catch {
                completion(error, nil)
            }
        }
    }

    public static func save(_ object: PFObject, completion: @escaping (Swift.Error?) -> Void) {
        background {
            do {
                try save(object)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}