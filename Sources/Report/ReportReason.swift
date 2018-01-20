//
//  ReportReason.swift
//  Core
//
//  Created by Pranjal Satija on 1/20/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

/// The various reasons that a user may report an event.
public enum ReportReason: String {
    case inappropriate
    case incorrectInfo
    case spammy
}

// MARK: Report Extension
public extension Report {
    typealias Reason = ReportReason
}
