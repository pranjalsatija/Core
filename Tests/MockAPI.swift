//
//  MockAPI.swift
//  Core
//
//  Created by Pranjal Satija on 1/12/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core

/// Used as a mock for the Parse API during unit testing.
/// Use `MockAPI.onFileDownload`, `onSave`, and `onQuery` to catch and respond to API requests.
struct MockAPI {
    typealias FileDownloadHandler = (PFFile) throws -> Data
    typealias FunctionCallHandler = (CloudFunction, [AnyHashable : Any]?) throws -> Any
    typealias LogInHandler = (String, String) throws -> PFUser
    typealias LogOutHandler = () throws -> Void
    typealias SaveHandler = (PFObject) throws -> Void
    typealias QueryHandler<T: PFObject> = (PFQuery<T>) throws -> [T]

    static var fileDownloadHandler: FileDownloadHandler?
    static var functionCallHandler: FunctionCallHandler?
    static var logInHandler: LogInHandler?
    static var logOutHandler: LogOutHandler?
    static var saveHandler: SaveHandler?
    static var queryHandler: QueryHandler<PFObject>?
}

// MARK: Catching API Requests
extension MockAPI {
    static func cleanUp() {
        fileDownloadHandler = nil
        functionCallHandler = nil
        logInHandler = nil
        logOutHandler = nil
        saveHandler = nil
        queryHandler = nil
    }

    static func onFileDownload(_ block: @escaping FileDownloadHandler) {
        fileDownloadHandler = block
    }

    static func onFunctionCall(_ block: @escaping FunctionCallHandler) {
        functionCallHandler = block
    }

    static func onLogIn(_ block: @escaping LogInHandler) {
        logInHandler = block
    }

    static func onLogOut(_ block: @escaping LogOutHandler) {
        logOutHandler = block
    }

    static func onSave(_ block: @escaping SaveHandler) {
        saveHandler = block
    }

    static func onQuery(_ block: @escaping QueryHandler<PFObject>) {
        queryHandler = block
    }
}

// MARK: APIProtocol
extension MockAPI: APIProtocol {
    static func call(_ function: CloudFunction, parameters: [AnyHashable : Any]?) throws -> Any {
        return try functionCallHandler?(function, parameters) as Any
    }

    static func findFirstObject<T>(matching query: PFQuery<T>) throws -> T {
        if let query = query as? PFQuery<PFObject>, let objects = try queryHandler?(query), let first = objects.first {
            //swiftlint:disable:next force_cast
            return first as! T
        } else {
            throw Error.unknown
        }
    }

    static func getData(from file: PFFile) throws -> Data {
        if let block = fileDownloadHandler {
            return try block(file)
        } else {
            print("Warning: MockAPI.getData(from:) was called, but there's no handler for file downloads.")
            throw Error.missingData
        }
    }

    static func findObjects<T>(matching query: PFQuery<T>) throws -> [T] {
        if let query = query as? PFQuery<PFObject>, let objects = try queryHandler?(query) {
            //swiftlint:disable:next force_cast
            return objects as! [T]
        } else {
            throw Error.unknown
        }
    }

    static func logIn(withUsername username: String, password: String) throws -> PFUser {
        guard let logInHandler = logInHandler else {
            throw Core.Error.missingData
        }

        return try logInHandler(username, password)
    }

    static func logOut() throws {
        try logOutHandler?()
    }

    static func save(_ object: PFObject) throws {
        try saveHandler?(object)
    }

    static func saveEventually(_ object: PFObject) {
        try? saveHandler?(object)
    }
}
