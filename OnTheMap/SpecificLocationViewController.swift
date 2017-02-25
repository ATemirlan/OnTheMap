//
//  SpecificLocationViewController.swift
//  OnTheMap
//
//  Created by Temirlan on 19.02.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit
import MapKit

class SpecificLocationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    var me: Student?
    var location: StudentLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = me {
            location = StudentLocation(student: me!)
            mapView.addAnnotation(location!)
            let region = MKCoordinateRegionMakeWithDistance(location!.coordinate, 10000, 10000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    @IBAction func finish(_ sender: Any) {
        if let _ = me {
            if let _ = me?.objectId {
                updateLocation()
            } else {
                postNewLocation()
            }
        }
    }
    
    func postNewLocation() {
        RequestEngine.shared.postStudentLocation(student: self.me!, and: { (posted, error) in
            if let _ = error {
                Utils.showError(with: error!, at: self)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    func updateLocation() {
        RequestEngine.shared.updateStudentLocation(student: self.me!) { (posted, error) in
            if let _ = error {
                Utils.showError(with: error!, at: self)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
