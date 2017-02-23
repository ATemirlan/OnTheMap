//
//  Student.swift
//  OnTheMap
//
//  Created by Temirlan on 18.02.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit
import MapKit

class Student: NSObject, MKAnnotation {
    
    var uniqueKey: String?
    var objectId: String?
    var firstName: String?
    var lastName: String?
    var location: CGPoint?
    var mapString: String?
    var mediaUrl: String?
    var createdAt: String?
    var updatedAt: String?
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
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
            self.subtitle = self.mediaUrl
        }
        
        if let latitude = dictionary["latitude"] as? CGFloat, let longitude = dictionary["longitude"] as? CGFloat {
            self.location = CGPoint(x: latitude, y: longitude)
        } else {
            self.location = CGPoint(x: 0.0, y: 0.0)
        }
        
        self.coordinate = CLLocationCoordinate2D(latitude: Double(self.location!.x), longitude: Double(self.location!.y))
        
        if let _ = firstName, let _ = lastName {
            self.title = self.firstName! + " " + self.lastName!
        }
        
        super.init()
    }
   
}
