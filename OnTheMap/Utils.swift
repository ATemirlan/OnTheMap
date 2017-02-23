//
//  Utils.swift
//  OnTheMap
//
//  Created by Temirlan on 18.02.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class Utils: NSObject {

    static func showError(with text: String, at controller: UIViewController) {
        DispatchQueue.main.async {
            Utils.removeIndicator()
            
            let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            })
            
            controller.present(alert, animated: true, completion: nil)
        }
    }
    
    static func showIndicator() {
        DispatchQueue.main.async {
            let window = UIApplication.shared.keyWindow!
            let dimView = UIView(frame: window.frame)
            dimView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
            dimView.tag = 13
            indicator.center = dimView.center
            indicator.startAnimating()
            dimView.addSubview(indicator)
            window.bringSubview(toFront: dimView)
            window.addSubview(dimView)
        }
    }
    
    static func removeIndicator() {
        DispatchQueue.main.async {
            let window = UIApplication.shared.keyWindow!
            for v in window.subviews {
                if v.tag == 13 {
                    v.removeFromSuperview()
                }
            }
        }
    }
    
}
