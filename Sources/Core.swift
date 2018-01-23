//
//  Core.swift
//  Core
//
//  Created by Pranjal Satija on 1/21/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

public func initialize(withAppID appID: String, serverURL: String) {
    let config = ParseClientConfiguration {(config) in
        config.applicationId = appID
        config.server = serverURL
    }

    Parse.initialize(with: config)

    Event.registerSubclass()
    Like.registerSubclass()
    NotificationOpen.registerSubclass()
    Referral.registerSubclass()
    Report.registerSubclass()
    Session.registerSubclass()
    Share.registerSubclass()
    View.registerSubclass()
    Visit.registerSubclass()
}

public func clearFileCaches() {
    PFFile.clearAllCachedDataInBackground()
}

public func registerForNotifications(withToken token: Data) {
    guard let installation = PFInstallation.current() else {
        return
    }

    installation.setDeviceTokenFrom(token)
    installation.saveEventually()
}
