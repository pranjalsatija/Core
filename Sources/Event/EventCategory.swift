//
//  EventCategory.swift
//  Core
//
//  Created by Pranjal Satija on 1/16/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import UIKit

/// Represents the various categories that events can have.
public class EventCategory: Object {
    @NSManaged public var iconFile: PFFile!
    @NSManaged public var iconFileScaleFactor: NSNumber!
    @NSManaged public var name: String!
}

// MARK: Images
public extension EventCategory {
    /// Downloads this category's icon image.
    func getIconImage(from api: APIProtocol.Type = ParseAPI.self,
                      completion: @escaping CompletionHandler<UIImage>) {

        api.getData(from: iconFile) {(error, data) in
            if let error = error {
                main { completion(error, nil) }
            } else if let data = data, let image = UIImage(data: data), let cgImage = image.cgImage {
                let rescaledImage = UIImage(
                    cgImage: cgImage, scale:
                    CGFloat(truncating: self.iconFileScaleFactor),
                    orientation: image.imageOrientation
                ).withRenderingMode(.alwaysTemplate)

                main { completion(nil, rescaledImage) }
            } else {
                main { completion(Error.invalidResponseFormat, nil) }
            }
        }
    }
}

// MARK: PFSubclassing
extension EventCategory: PFSubclassing {
    public static func parseClassName() -> String {
        return "Category"
    }
}

// MARK: Event Extension
extension Event {
    public typealias Category = EventCategory
}
