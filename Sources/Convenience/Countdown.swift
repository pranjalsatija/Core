//
//  Countdown.swift
//  Core
//
//  Created by Pranjal Satija on 1/23/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import Foundation

public class Countdown {
    private var remainingTime: TimeInterval
    private var timer: Timer!
    public var duration: TimeInterval

    public init(duration: TimeInterval, granularity: TimeInterval = 0.1, completion: @escaping () -> Void) {
        self.duration = duration
        self.remainingTime = duration

        timer = Timer.scheduledTimer(withTimeInterval: granularity, repeats: true) {(_) in
            self.remainingTime -= granularity
            if self.remainingTime <= 0 {
                completion()
            }
        }
    }

    public static func start(duration: TimeInterval,
                             granularity: TimeInterval = 0.1,
                             completion: @escaping () -> Void) {

        _ = Countdown(duration: duration, granularity: granularity, completion: completion)
    }
}
