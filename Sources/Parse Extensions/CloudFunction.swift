//
//  CloudFunction.swift
//  Core
//
//  Created by Pranjal Satija on 1/20/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

public struct CloudFunction {
    let name: String

    private init(name: String) {
        self.name = name
    }
}

extension CloudFunction {
    static var beginPhoneNumberAuthentication: CloudFunction {
        return CloudFunction(name: "beginPhoneNumberAuth")
    }

    static var finishPhoneNumberAuthentication: CloudFunction {
        return CloudFunction(name: "finishPhoneNumberAuth")
    }
}

extension CloudFunction: Equatable {
    public static func == (lhs: CloudFunction, rhs: CloudFunction) -> Bool {
        return lhs.name == rhs.name
    }
}
