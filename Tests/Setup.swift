//
//  Setup.swift
//  Core
//
//  Created by Pranjal Satija on 1/12/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

@testable import Core
import Parse

private var setupWasPerformed = false
func performSetupIfNeeded() {
    guard !setupWasPerformed else {
        return
    }

    let config = ParseClientConfiguration {(config) in
        config.applicationId = "mark"
        config.server = "https://api.mark.events/parse"
    }

    Parse.initialize(with: config)
    setupWasPerformed = true
}
