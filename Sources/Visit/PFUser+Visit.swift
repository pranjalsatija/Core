//
//  PFUser+Visit.swift
//  Core
//
//  Created by Pranjal Satija on 1/21/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

public extension User {
    func registerVisit(with event: Event, using api: APIProtocol.Type = ParseAPI.self) {
        Visit.create(with: event, user: self, using: api)
    }

    func getVisits(using api: APIProtocol.Type = ParseAPI.self, completion: @escaping CompletionHandler<[Visit]>) {
        Visit.getVisits(forUser: self, using: api, completion: completion)
    }
}
