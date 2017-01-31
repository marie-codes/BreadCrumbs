//
//  Crumb.swift
//  Crumbs
//
//  Created by Forrest Zhao on 11/19/16.
//  Copyright © 2016 NY3. All rights reserved.
//

import UIKit
import FirebaseDatabase

struct Crumb {
    
    var key: String
    var userKey: String
    var name: String
    var city: String
    //var rating: Int?
    //var locations: [Location] = []
    let ref: FIRDatabaseReference?
    
    init(name: String, key: String = "", userKey: String, city: String) {
        self.key = key
        self.name = name
        self.userKey = userKey
        self.city = city
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.name = snapshotValue["name"] as! String
        self.userKey = snapshotValue["userKey"] as! String
        if let unwrappedCityName = snapshotValue["city"] {
            self.city =  unwrappedCityName as! String
        }
        else {
            self.city = ""
        }
        //        self.rating = snapshotValue["rating"] as? Int
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "userKey": userKey,
            "city": city
            //"rating": rating!
        ]
    }
    
}
