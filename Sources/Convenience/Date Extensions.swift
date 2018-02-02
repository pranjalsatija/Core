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

    var months: TimeInterval {
        return weeks * 4
    }

    var years: TimeInterval {
        return months * 12
    }
}

public extension Date {
    var relativeDescription: String {
        return relativeDescription(referenceDate: Date())
    }

    func relativeDescription(referenceDate date: Date) -> String {
        var baseString = ""
        let secondsFromNow = abs(Int(timeIntervalSince(date)))
        let minutesFromNow = abs(Int(timeIntervalSince(date) / 1.minutes))
        let hoursFromNow = abs(Int(timeIntervalSince(date) / 1.hours))
        let daysFromNow = abs(Int(timeIntervalSince(date) / 1.days))
        let monthsFromNow = abs(Int(timeIntervalSince(date) / 1.months))
        let yearsFromNow = abs(Int(timeIntervalSince(date) / 1.years))

        if abs(timeIntervalSince(date)) < 1.minutes {
            baseString = "\(secondsFromNow) \(secondsFromNow == 1 ? "second" : "seconds")"
        } else if abs(timeIntervalSince(date)) < 1.hours {
            baseString = "\(minutesFromNow) \(minutesFromNow == 1 ? "minute" : "minutes")"
        } else if abs(timeIntervalSince(date)) < 1.days {
            baseString = "\(hoursFromNow) \(hoursFromNow == 1 ? "hour" : "hours")"
        } else if abs(timeIntervalSince(date)) < 1.months {
            baseString = "\(daysFromNow) \(daysFromNow == 1 ? "day" : "days")"
        } else if abs(timeIntervalSince(date)) < 1.years {
            baseString = "\(monthsFromNow) \(monthsFromNow == 1 ? "month" : "months")"
        } else {
            baseString = "\(yearsFromNow) \(yearsFromNow == 1 ? "year" : "years")"
        }

        if timeIntervalSince(date) < 0 {
            return baseString + " ago"
        } else {
            return "in " + baseString
        }
    }
}
