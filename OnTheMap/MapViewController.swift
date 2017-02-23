//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Temirlan on 18.02.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var students: [Student]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
    }
    
    func receiveNotification(notification: Notification) {
        if let students = notification.object as? [Student]? {
            self.students = students
            self.mapView.addAnnotations(students!)
        }
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Student {
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                view.canShowCallout = true
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            
            return view
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation {
            if let url = annotation.subtitle, UIApplication.shared.canOpenURL(URL(string: url!)!) {
                UIApplication.shared.open(URL(string: url!)!, options: [:], completionHandler: nil)
            } else {
                Utils.showError(with: "Invalid Link", at: self)
            }
        }
    }

}
