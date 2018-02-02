//
//  Core.swift
//  Core
//
//  Created by Pranjal Satija on 1/21/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import Instabug

public func initialize(withAppID appID: String, serverURL: String, instabugToken: String) {
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

    Instabug.start(withToken: instabugToken, invocationEvent: .shake)
    Instabug.setIntroMessageEnabled(false)
    Instabug.setPrimaryColor(UIColor(red: 61 / 255, green: 167 / 255, blue: 255 / 255, alpha: 1))
    Instabug.setPromptOptionsEnabledWithBug(true, feedback: true, chat: false)
}

public func clearFileCaches() {
    PFFile.clearAllCachedDataInBackground()
}

public func provideFeedback() {
    Instabug.invoke()
}

public func registerForNotifications(withToken token: Data) {
    guard let installation = PFInstallation.current() else {
        return
    }

    installation.setDeviceTokenFrom(token)
    installation.saveEventually()
}
