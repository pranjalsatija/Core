//
//  Event.swift
//  Core
//
//  Created by Pranjal Satija on 1/14/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

/// Used to represent events on mark.
public class Event: Object {
    // MARK: Model Properties
    @NSManaged public var category: Category!
    @NSManaged public var coverPhoto: PFFile?
    @NSManaged public var eventDescription: String!
    @NSManaged public var likeCount, visitCount: NSNumber!
    @NSManaged public var location: PFGeoPoint!
    @NSManaged public var radius: NSNumber!

    public var origin: Origin? {
        let originString = self["origin"] as? String
        return Origin(originString)
    }

    public var originURL: URL? {
        guard let originURLString = self["originURL"] as? String else { return nil }
        return URL(string: originURLString)
    }

    @NSManaged public var score: NSNumber!
    @NSManaged public var startDate, endDate: Date!
    @NSManaged public var title: String!

    // MARK: Local Properties
    public var duration: TimeInterval {
        return endDate.timeIntervalSince(startDate)
    }

    public var isCurrentlyOccurring: Bool {
        return (startDate...endDate).contains(Date())
    }

    public var isEndingSoon: Bool {
        return endDate > Date() && endDate.timeIntervalSinceNow < duration * 0.2
    }

    public var relevance = 0.0
}

// MARK: Event Data
extension Event {
    public func getCoverPhoto(api: APIProtocol.Type = ParseAPI.self, completion: @escaping CompletionHandler<UIImage>) {
        guard let coverPhoto = coverPhoto else {
            completion(Error.missingData, nil)
            return
        }

        api.getData(from: coverPhoto) {(error, data) in
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

    public static func getRelevantEvents(in geoBox: GeoBox,
                                         categories: [Category],
                                         limit: Int = 50,
                                         api: APIProtocol.Type = ParseAPI.self,
                                         completion: @escaping CompletionHandler<[Event]>) {

        //swiftlint:disable:next force_cast
        let currentlyOccuringQuery = baseQuery() as! PFQuery<PFObject>
        currentlyOccuringQuery.whereKey("startDate", lessThan: Date())
        currentlyOccuringQuery.whereKey("endDate", greaterThan: Date())

        //swiftlint:disable:next force_cast
        let upcomingQuery = baseQuery() as! PFQuery<PFObject>
        upcomingQuery.whereKey("startDate", greaterThan: Date())
        upcomingQuery.whereKey("startDate", lessThan: Date().addingTimeInterval(24.hours))

        let southwest = PFGeoPoint(geoBox.southwest), northeast = PFGeoPoint(geoBox.northeast)
        let combinedQuery = PFQuery.orQuery(withSubqueries: [currentlyOccuringQuery, upcomingQuery])
        combinedQuery.whereKey("category", containedIn: categories)
        combinedQuery.whereKey("location", withinGeoBoxFromSouthwest: southwest, toNortheast: northeast)
        combinedQuery.addDescendingOrder("score")
        combinedQuery.limit = limit

        api.findObjects(matching: combinedQuery) {(error, objects) in
            if let error = error {
                completion(error, nil)
            } else if let events = objects as? [Event] {
                completion(nil, events)
            } else {
                completion(Error.invalidResponseFormat, nil)
            }
        }
    }
}

// MARK: PFSubclassing
extension Event: PFSubclassing {
    public static func parseClassName() -> String {
        return "Event"
    }
}
