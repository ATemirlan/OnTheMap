//
//  Student.swift
//  OnTheMap
//
//  Created by Temirlan on 18.02.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class Student: NSObject, NSCoding {
    
    var uniqueKey: String?
    var objectId: String?
    var firstName: String! = "[No Name]"
    var lastName: String! = "[No LastName]"
    var mapString: String?
    var mediaUrl: String?
    var createdAt: String?
    var updatedAt: String?
    var latStr: String?
    var lonStr: String?
    
    var latitude: Double?
    var longitude: Double?
    
    init?(with dictionary: [String : AnyObject]) {
        
        if let key = dictionary["uniqueKey"] as? String {
            self.uniqueKey = key
        }
        
        if let id = dictionary["objectId"] as? String {
            self.objectId = id
        }
        
        if let created = dictionary["createdAt"] as? String {
            self.createdAt = created
        }
        
        if let updated = dictionary["updatedAt"] as? String {
            self.updatedAt = updated
        }
        
        if let fName = dictionary["firstName"] as? String {
            self.firstName = fName
        }
        
        if let lName = dictionary["lastName"] as? String {
            self.lastName = lName
        }
        
        if let mapString = dictionary["mapString"] as? String {
            self.mapString = mapString
        }
        
        if let mediaUrl = dictionary["mediaURL"] as? String {
            self.mediaUrl = mediaUrl
        }
        
        if let latitude = dictionary["latitude"] as? Double {
            self.latitude = latitude
        }
        
        if let longitude = dictionary["longitude"] as? Double {
            self.longitude = longitude
        }
        
        super.init()
    }
   
    required init?(coder aDecoder: NSCoder) {
        
        self.firstName = aDecoder.decodeObject(forKey: "firstName") as? String
        self.lastName = aDecoder.decodeObject(forKey: "lastName") as? String
        self.objectId = aDecoder.decodeObject(forKey: "objectId") as? String
        self.uniqueKey = aDecoder.decodeObject(forKey: "uniqueKey") as? String
        self.mediaUrl = aDecoder.decodeObject(forKey: "mediaUrl") as? String
        self.mapString = aDecoder.decodeObject(forKey: "mapString") as? String
        self.createdAt = aDecoder.decodeObject(forKey: "createdAt") as? String
        self.updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? String
        
        let latitudeLiteral = aDecoder.decodeObject(forKey: "latitude") as? String
        let longitudeLiteral = aDecoder.decodeObject(forKey: "longitude") as? String
        
        self.latitude = Double(latitudeLiteral ?? "90.0")
        self.longitude = Double(longitudeLiteral ?? "90.0")
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(objectId, forKey: "objectId")
        aCoder.encode(uniqueKey, forKey: "uniqueKey")
        aCoder.encode(mediaUrl, forKey: "mediaUrl")
        aCoder.encode(mapString, forKey: "mapString")
        aCoder.encode(createdAt, forKey: "createdAt")
        aCoder.encode(updatedAt, forKey: "updatedAt")

        aCoder.encode(latitude?.toString(), forKey: "latitude")
        aCoder.encode(longitude?.toString(), forKey: "longitude")
    }
}
