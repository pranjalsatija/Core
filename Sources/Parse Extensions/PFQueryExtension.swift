//
//  PFQueryExtension.swift
//  Core
//
//  Created by Pranjal Satija on 1/12/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

func PFQueryGetState(_ query: PFQuery<PFObject>?) -> NSObject? {
    return query?.value(forKey: "state") as? NSObject
}

func PFQueryGetConditions(_ query: PFQuery<PFObject>?) -> [String: Any]? {
    return PFQueryGetState(query)?.value(forKey: "conditions") as? [String: Any]
}

func PFQueryGetSortKeys(_ query: PFQuery<PFObject>?) -> [String]? {
    return PFQueryGetState(query)?.value(forKey: "sortKeys") as? [String]
}
