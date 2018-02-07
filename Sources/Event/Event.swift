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
        guard let originURLString = self["originURL"] as? String else {
            return nil
        }

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

// MARK: Additional Information
public extension Event {
    func getCoverPhoto(from api: APIProtocol.Type = ParseAPI.self, completion: @escaping CompletionHandler<UIImage>) {
        guard let coverPhoto = coverPhoto else {
            main { completion(Error.missingData, nil) }
            return
        }

        api.getData(from: coverPhoto) {(error, data) in
            if let error = error {
                main { completion(error, nil) }
            } else if let data = data, let image = UIImage(data: data) {
                main { completion(nil, image) }
            } else {
                main { completion(Error.invalidResponseFormat, nil) }
            }
        }
    }

    override var description: String {
        guard let categoryName = category.name, let eventDescription = eventDescription else {
            return super.description
        }

        return "\(categoryName) - \(eventDescription)"
    }

    var likeCountMessage: String? {
        guard likeCount.intValue > 0 else {
            return nil
        }

        if likeCount == 1 {
            return "\(likeCount.intValue) person has liked this event."
        } else {
            return "\(likeCount.intValue) people have liked this event."
        }
    }

    var mapsURL: URL? {
        return URL.mapsURL(for: self)
    }

    var shareURL: URL? {
        return URL.shareURL(for: self)
    }

    var statusMessage: String {
        if Calendar.current.isDateInToday(startDate) {
            return "This event is starting at \(startDate.timeString) today. That's \(startDate.relativeDescription)."
        } else if startDate > Date() {
            return "This event is starting at \(startDate.timeString) on \(startDate.dateString)."
        } else if endDate > Date() {
            return "This event is ending \(endDate.relativeDescription)."
        } else {
            return "This event ended \(endDate.relativeDescription)."
        }
    }

    var visitCountMessage: String? {
        guard visitCount.intValue > 0 else {
            return nil
        }

        if visitCount == 1 {
            return "\(visitCount.intValue) person has visited this event."
        } else {
            return "\(visitCount.intValue) people have visited this event."
        }
    }
}

// MARK: User API
extension Event {
    func userIsPresent(_ user: User) -> Bool {
        guard let location = user.location.value, let startDate = startDate, let endDate = endDate else {
            return false
        }

        return (location.distance(from: self.location) < radius.doubleValue) && (startDate...endDate).contains(Date())
    }
}

// MARK: Queries
public extension Event {
    static func getCurrentlyOccurringEvents(near location: LocationType,
                                            maxDistance: Double,
                                            limit: Int = 20,
                                            from api: APIProtocol.Type = ParseAPI.self,
                                            completion: @escaping CompletionHandler<[Event]>) {
        let query = baseQuery()
        query.whereKey("location", nearGeoPoint: PFGeoPoint(location), withinKilometers: maxDistance)
        query.whereKey("startDate", lessThan: Date())
        query.whereKey("endDate", greaterThan: Date())
        query.limit = limit
        api.findObjects(matching: query) {(error, events) in
            main { completion(error, events) }
        }
    }

    static func getRelevantEvents(in geoBox: GeoBox,
                                  categories: [Category]?,
                                  limit: Int = 50,
                                  from api: APIProtocol.Type = ParseAPI.self,
                                  completion: @escaping CompletionHandler<[Event]>) {

        //swiftlint:disable:next force_cast
        let currentlyOccuringQuery = baseQuery() as! PFQuery<PFObject>
        currentlyOccuringQuery.whereKey("startDate", lessThan: Date())
        currentlyOccuringQuery.whereKey("endDate", greaterThan: Date())

        //swiftlint:disable:next force_cast
        let upcomingQuery = baseQuery() as! PFQuery<PFObject>
        upcomingQuery.whereKey("startDate", greaterThan: Date())
        upcomingQuery.whereKey("startDate", lessThan: Date().addingTimeInterval(24.hours))

        let southwest = PFGeoPoint(geoBox.southwest.standardized()), northeast = PFGeoPoint(geoBox.northeast.standardized())
        let combinedQuery = PFQuery.orQuery(withSubqueries: [currentlyOccuringQuery, upcomingQuery])

        if let categories = categories {
            combinedQuery.whereKey("category", containedIn: categories)
        }

        combinedQuery.whereKey("location", withinGeoBoxFromSouthwest: southwest, toNortheast: northeast)
        combinedQuery.addDescendingOrder("score")
        combinedQuery.includeKey("category")
        combinedQuery.limit = limit

        api.findObjects(matching: combinedQuery) {(error, objects) in
            if let error = error {
                main { completion(error, nil) }
            } else if let events = objects as? [Event] {
                main { completion(nil, events) }
            } else {
                main { completion(Error.invalidResponseFormat, nil) }
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
