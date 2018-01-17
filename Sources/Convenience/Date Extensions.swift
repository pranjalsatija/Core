//
//  Date Extensions.swift
//  Core
//
//  Created by Pranjal Satija on 1/16/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

// MARK: Int Extension
extension Int {
    var seconds: TimeInterval {
        return Double(self)
    }

    var minutes: TimeInterval {
        return seconds * 60
    }

    var hours: TimeInterval {
        return minutes * 60
    }

    var days: TimeInterval {
        return hours * 24
    }

    var weeks: TimeInterval {
        return days * 7
    }
}
