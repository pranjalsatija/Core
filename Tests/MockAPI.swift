//
//  MockAPI.swift
//  Core
//
//  Created by Pranjal Satija on 1/12/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core

struct MockAPI: APIProtocol {
    typealias OnSaveBlock = (PFObject) throws -> Void
    typealias OnQueryBlock<T: PFObject> = (PFQuery<T>) throws -> [T]

    static var onSaveBlock: OnSaveBlock?
    static var onQueryBlock: OnQueryBlock<PFObject>?
}

extension MockAPI {
    static func findFirstObject<T>(query: PFQuery<T>) throws -> T {
        if let query = query as? PFQuery<PFObject>, let objects = try onQueryBlock?(query), let first = objects.first {
            //swiftlint:disable:next force_cast
            return first as! T
        } else {
            throw Error.unknown
        }
    }

    static func findObjects<T>(query: PFQuery<T>) throws -> [T] {
        if let query = query as? PFQuery<PFObject>, let objects = try onQueryBlock?(query) {
            //swiftlint:disable:next force_cast
            return objects as! [T]
        } else {
            throw Error.unknown
        }
    }

    static func save(_ object: PFObject) throws {
        try onSaveBlock?(object)
    }

    static func saveEventually(_ object: PFObject) {
        try? onSaveBlock?(object)
    }
}

extension MockAPI {
    static func onSave(_ block: @escaping OnSaveBlock) {
        onSaveBlock = block
    }

    static func onQuery(_ block: @escaping OnQueryBlock<PFObject>) {
        onQueryBlock = block
    }
}
