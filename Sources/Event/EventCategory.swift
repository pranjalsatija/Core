//
//  EventCategory.swift
//  Core
//
//  Created by Pranjal Satija on 1/16/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

/// Represents the various categories that events can have.
public class EventCategory: PFObject {
    @NSManaged public var iconFile: PFFile!
    @NSManaged public var name: String!
}

// MARK: Images
extension EventCategory {
    /// Downloads this category's icon image.
    public func getIconImage(api: APIProtocol.Type = ParseAPI.self,
                             _ completion: @escaping CompletionHandler<UIImage>) {
        api.getData(from: iconFile) {(error, data) in
            if let error = error {
                completion(error, nil)
            } else if let data = data, let image = UIImage(data: data) {
                completion(nil, image)
            } else {
                completion(Error.invalidResponseFormat, nil)
            }
        }
    }
}

// MARK: PFSubclassing
extension EventCategory: PFSubclassing {
    public static func parseClassName() -> String {
        return "EventCategory"
    }
}

// MARK: Event Extension
extension Event {
    public typealias Category = EventCategory
}
