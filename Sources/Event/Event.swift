//
//  Event.swift
//  Core
//
//  Created by Pranjal Satija on 1/14/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

/// Used to represent events on mark.
public class Event: PFObject {
    // MARK: Model Properties
    @NSManaged public private(set) var coverPhoto: PFFile?
    @NSManaged public private(set) var eventDescription: String!
    @NSManaged public private(set) var likeCount, visitCount: NSNumber!
    @NSManaged public private(set) var location: PFGeoPoint!
    @NSManaged public private(set) var radius: NSNumber!

    public var origin: Origin? {
        let originString = self["origin"] as? String
        return Origin(originString)
    }

    public var originURL: URL? {
        guard let originURLString = self["originURL"] as? String else { return nil }
        return URL(string: originURLString)
    }

    @NSManaged public private(set) var startDate, endDate: Date!
    @NSManaged public private(set) var title: String!

    // MARK: Local Properties
    public var duration: TimeInterval {
        return endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970
    }

    public var isCurrentlyOccurring: Bool {
        return (startDate...endDate).contains(Date())
    }

    public var isEndingSoon: Bool {
        return endDate > Date() && endDate.timeIntervalSinceNow < duration * 0.2
    }
}

// MARK: Event Data
extension Event {
    public func getCoverPhoto(api: APIProtocol.Type = ParseAPI.self, completion: @escaping FetchImageHandler) {
        guard let coverPhoto = coverPhoto else {
            completion(Error.missingData(description: "This event doesn't have a cover photo."), nil)
            return
        }

        api.getData(from: coverPhoto) {(error, data) in
            if let error = error {
                completion(error, nil)
            } else if let data = data, let image = UIImage(data: data) {
                completion(nil, image)
            } else {
                completion(Error.unknown, nil)
            }
        }
    }
}

// MARK: Queries
extension Event {
    public static func getCurrentlyOccurringEvents(near location: LocationProtocol,
                                                   maxDistance: Double,
                                                   limit: Int = 20,
                                                   api: APIProtocol.Type = ParseAPI.self,
                                                   completion: @escaping CompletionHandler<[Event]>) {
        let query = baseQuery()
        query.whereKey("location", nearGeoPoint: PFGeoPoint(location), withinKilometers: maxDistance)
        query.whereKey("startDate", lessThan: Date())
        query.whereKey("endDate", greaterThan: Date())
        query.limit = limit
        api.findObjects(matching: query) {(error, events) in
            completion(error, events)
        }
    }
}

// MARK: Completion Handlers
extension Event {
    public typealias FetchImageHandler = (Swift.Error?, UIImage?) -> Void
}

// MARK: PFSubclassing
extension Event: PFSubclassing {
    public static func parseClassName() -> String {
        return "Event"
    }
}
