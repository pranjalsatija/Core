//
//  Portal.swift
//  Core
//
//  Created by Pranjal Satija on 1/20/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import Foundation

/// Can be used to create a stream of observable values throughout an app.
/// Each portal has a name. You open a portal by using its initializer and providing a name.
/// Once you have a portal, you can observe its values by using `observeUpdates`.
/// When you update a portal's value,
/// all of the portals that currently exist in memory that have the same name will receive the update.
public class Portal<Value> {
    public let name: String


    var notificationCenter = NotificationCenter.default
    var notificationName: Notification.Name {
        return Notification.Name(name)
    }


    private var observationTokens = [NSObjectProtocol]()


    init(name: String) {
        self.name = name
    }

    deinit {
        observationTokens.forEach(notificationCenter.removeObserver)
    }
}

// MARK: Observation
public extension Portal {
    typealias Observer = (Value) -> Void

    func observeUpdates(on queue: OperationQueue = .main, using block: @escaping Observer) {
        let observer = notificationCenter.addObserver(forName: notificationName,
                                                      object: nil,
                                                      queue: queue) {(notification) in

            guard let value = notification.object as? Value else {
                return
            }

            block(value)
        }

        observationTokens.append(observer)
    }

    func postUpdate(value: Value) {
        notificationCenter.post(name: Notification.Name(name), object: value)
    }
}
