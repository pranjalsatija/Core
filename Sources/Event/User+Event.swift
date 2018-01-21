//
//  User+Event.swift
//  Core
//
//  Created by Pranjal Satija on 1/20/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

public extension User {
    func isAt(_ event: Event) -> Bool {
        return event.userIsPresent(self)
    }
}
