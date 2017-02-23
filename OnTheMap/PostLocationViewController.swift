//
//  PostLocationViewController.swift
//  OnTheMap
//
//  Created by Temirlan on 19.02.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit
import MapKit

class PostLocationViewController: UIViewController {

    let segue = "ShowLocation"
    var me: Student?
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var websiteField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if me == nil {
            RequestEngine.shared.getUserInfo(with: { (response, error) in
                if let _ = error {
                    Utils.showError(with: error!, at: self)
                } else {
                    if let _ = response {
                        self.me = Student(with: response!)
                    }
                }
            })
        }
    }
    
    @IBAction func findLocation(_ sender: Any) {
        Utils.showIndicator()
        
        if (locationField.text?.characters.count)! > 0 {
            if (websiteField.text!.hasPrefix("http://") || websiteField.text!.hasPrefix("https://")) {
                getLocation(from: locationField.text!, completion: { (coordinates) in
                    if let _ = coordinates {
                        Utils.removeIndicator()
                        
                        self.me?.coordinate = coordinates!
                        self.me?.location = CGPoint(x: coordinates!.latitude, y: coordinates!.longitude)
                        self.me?.mapString = self.locationField.text
                        self.me?.mediaUrl = self.websiteField.text
                        self.me?.subtitle = self.websiteField.text
                        
                        self.performSegue(withIdentifier: self.segue, sender: self.me)
                    } else {
                        Utils.showError(with: "No such location", at: self)
                    }
                })
                
            } else {
                Utils.showError(with: "URL should start with: http:// or https://", at: self)
            }
        } else {
            Utils.showError(with: "Location was not specified", at: self)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func getLocation(from string: String, completion: @escaping (_ coordinates: CLLocationCoordinate2D?) -> Void) {
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = string
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            if error == nil {
                let coordinates = CLLocationCoordinate2D(latitude: response!.boundingRegion.center.latitude, longitude: response!.boundingRegion.center.longitude)
                completion(coordinates)
            } else {
                completion(nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == self.segue {
            let vc = segue.destination as! SpecificLocationViewController
            vc.me = sender as? Student
        }
    }
    
}
