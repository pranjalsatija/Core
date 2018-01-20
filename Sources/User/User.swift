//
//  User.swift
//  Core
//
//  Created by Pranjal Satija on 1/20/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

public class User: PFUser {
    static var current: User? {
        return PFUser.current() as? User
    }
}

// MARK: Authentication
public extension User {
    static func sendPIN(to phoneNumber: String,
                        using api: APIProtocol.Type,
                        completion: @escaping CompletionHandler<User>) {

        api.call(.beginPhoneNumberAuthentication, parameters: [
            "phoneNumber": phoneNumber
        ]) {(error, result) in
            if let error = error, (error as NSError).code == Error.invalidPhoneNumber.code {
                completion(Error.invalidPhoneNumber, nil)
            } else {
                completion(error, result as? User)
            }
        }
    }

    func verifyPIN(_ pin: String, using api: APIProtocol.Type, completion: @escaping CompletionHandler<Bool>) {
        guard let username = username else {
            completion(Core.Error.missingData, false)
            return
        }

        api.logIn(withUsername: username, password: pin) {(error, user) in
            if let error = error, (error as NSError).code == Error.invalidPIN.code {
                completion(Error.invalidPIN, nil)
            } else {
                completion(error, user != nil)
                background {
                    _ = try? api.call(.finishPhoneNumberAuthentication, parameters: nil)
                }
            }
        }
    }

    func logOut(using api: APIProtocol.Type, completion: @escaping (Swift.Error?) -> Void) {
        api.logOut(completion: completion)
    }
}
