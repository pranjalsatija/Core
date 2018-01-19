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
    static func findFirstObject<T>(matching: PFQuery<T>) throws -> T
    static func findObjects<T>(matching query: PFQuery<T>) throws -> [T]
    static func getData(from file: PFFile) throws -> Data
    static func save(_ object: PFObject) throws
    static func saveEventually(_ object: PFObject)

    // MARK: Asynchronous Methods
    static func findFirstObject<T>(matching query: PFQuery<T>, completion: @escaping (Swift.Error?, T?) -> Void)
    static func findObjects<T>(matching query: PFQuery<T>, completion: @escaping (Swift.Error?, [T]?) -> Void)
    static func getData(from file: PFFile, completion: @escaping (Swift.Error?, Data?) -> Void)
    static func save(_ object: PFObject, completion: @escaping (Swift.Error?) -> Void)
}

// MARK: Asynchronous Default Implementations
public extension APIProtocol {
    static func findFirstObject<T>(matching query: PFQuery<T>, completion: @escaping CompletionHandler<T>) {
        background {
            do {
                try completion(nil, findFirstObject(matching: query))
            } catch {
                completion(error, nil)
            }
        }
    }

    static func findObjects<T>(matching query: PFQuery<T>, completion: @escaping CompletionHandler<[T]>) {
        background {
            do {
                try completion(nil, findObjects(matching: query))
            } catch {
                completion(error, nil)
            }
        }
    }

    static func getData(from file: PFFile, completion: @escaping CompletionHandler<Data>) {
        background {
            do {
                try completion(nil, getData(from: file))
            } catch {
                completion(error, nil)
            }
        }
    }

    static func save(_ object: PFObject, completion: @escaping (Swift.Error?) -> Void) {
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
