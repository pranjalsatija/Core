//
//  MockAPI.swift
//  Core
//
//  Created by Pranjal Satija on 1/12/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core

struct MockAPI: APIProtocol {
    typealias FileDownloadHandler = (PFFile) throws -> Data
    typealias SaveHandler = (PFObject) throws -> Void
    typealias QueryHandler<T: PFObject> = (PFQuery<T>) throws -> [T]

    static var onFileDownloadBlock: FileDownloadHandler?
    static var onSaveBlock: SaveHandler?
    static var onQueryBlock: QueryHandler<PFObject>?
}

extension MockAPI {
    static func findFirstObject<T>(matching query: PFQuery<T>) throws -> T {
        if let query = query as? PFQuery<PFObject>, let objects = try onQueryBlock?(query), let first = objects.first {
            //swiftlint:disable:next force_cast
            return first as! T
        } else {
            throw Error.unknown
        }
    }

    static func getData(from file: PFFile) throws -> Data {
        guard let data = try onFileDownloadBlock?(file) else {
            throw Error.unknown
        }

        return data
    }

    static func findObjects<T>(matching query: PFQuery<T>) throws -> [T] {
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
    static func onFileDownload(_ block: @escaping FileDownloadHandler) {
        onFileDownloadBlock = block
    }

    static func onSave(_ block: @escaping SaveHandler) {
        onSaveBlock = block
    }

    static func onQuery(_ block: @escaping QueryHandler<PFObject>) {
        onQueryBlock = block
    }
}
