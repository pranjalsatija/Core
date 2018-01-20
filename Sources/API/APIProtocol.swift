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
    static func call(_ function: CloudFunction, parameters: [AnyHashable : Any]?) throws -> Any
    static func findFirstObject<T>(matching: PFQuery<T>) throws -> T
    static func findObjects<T>(matching query: PFQuery<T>) throws -> [T]
    static func getData(from file: PFFile) throws -> Data
    static func logIn(withUsername username: String, password: String) throws -> PFUser
    static func logOut() throws
    static func save(_ object: PFObject) throws
    static func saveEventually(_ object: PFObject)

    // MARK: Asynchronous Methods
    static func call(_ function: CloudFunction,
                     parameters: [AnyHashable : Any]?,
                     completion: @escaping CompletionHandler<Any>)

    static func findFirstObject<T>(matching query: PFQuery<T>, completion: @escaping CompletionHandler<T>)
    static func findObjects<T>(matching query: PFQuery<T>, completion: @escaping CompletionHandler<[T]>)
    static func getData(from file: PFFile, completion: @escaping CompletionHandler<Data>)
    static func logIn(withUsername username: String, password: String, completion: @escaping CompletionHandler<PFUser>)
    static func logOut(completion: @escaping (Swift.Error?) -> Void)
    static func save(_ object: PFObject, completion: @escaping (Swift.Error?) -> Void)
}

// MARK: Asynchronous Default Implementations
public extension APIProtocol {
    static func call(_ function: CloudFunction,
                     parameters: [AnyHashable : Any]?,
                     completion: @escaping CompletionHandler<Any>) {

        background {
            do {
                let result = try call(function, parameters: parameters)
                main { completion(nil, result) }
            } catch {
                main { completion(error, nil) }
            }
        }
    }

    static func findFirstObject<T>(matching query: PFQuery<T>, completion: @escaping CompletionHandler<T>) {
        background {
            do {
                let result = try findFirstObject(matching: query)
                main { completion(nil, result) }
            } catch {
                main { completion(error, nil) }
            }
        }
    }

    static func findObjects<T>(matching query: PFQuery<T>, completion: @escaping CompletionHandler<[T]>) {
        background {
            do {
                let result = try findObjects(matching: query)
                main { completion(nil, result) }
            } catch {
                main { completion(error, nil) }
            }
        }
    }

    static func getData(from file: PFFile, completion: @escaping CompletionHandler<Data>) {
        background {
            do {
                let result = try getData(from: file)
                main { completion(nil, result) }
            } catch {
                main { completion(error, nil) }
            }
        }
    }

    static func logIn(withUsername username: String,
                      password: String,
                      completion: @escaping CompletionHandler<PFUser>) {

        background {
            do {
                let result = try logIn(withUsername: username, password: password)
                main { completion(nil, result) }
            } catch {
                main { completion(error, nil) }
            }
        }
    }

    static func logOut(completion: @escaping (Swift.Error?) -> Void) {
        background {
            do {
                try logOut()
                main { completion(nil) }
            } catch {
                main { completion(error) }
            }
        }
    }

    static func save(_ object: PFObject, completion: @escaping (Swift.Error?) -> Void) {
        background {
            do {
                try save(object)
                main { completion(nil) }
            } catch {
                main { completion(error) }
            }
        }
    }
}
