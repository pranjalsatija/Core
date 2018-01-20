//
//  UserError.swift
//  Core
//
//  Created by Pranjal Satija on 1/20/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

public enum UserError: Int, Swift.Error {
    case invalidPIN = 101
    case invalidPhoneNumber = 142

    var code: Int {
        return rawValue
    }
}

extension User {
    public typealias Error = UserError
}
