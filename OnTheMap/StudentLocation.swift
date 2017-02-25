//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Temirlan on 25.02.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit
import MapKit

class StudentLocation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(student: Student) {
        self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(student.latitude!), longitude: CLLocationDegrees(student.longitude!))
        self.title = student.firstName + " " + student.lastName
        self.subtitle = student.mediaUrl
    }
}
