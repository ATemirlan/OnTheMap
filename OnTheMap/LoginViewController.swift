//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Temirlan on 12.02.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let signupURL: URL! = URL(string: "https://www.udacity.com/account/auth#!/signup")
    let segueID = "loginSuccessedSegue"
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func login(_ sender: UIButton) {
        if emailField.text!.characters.count > 0, passwordField.text!.characters.count > 0 {
            RequestEngine.shared.login(with: emailField.text!, password: passwordField.text!, and: { (loggedIn, error) in
                if loggedIn {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: self.segueID, sender: nil)
                    }
                } else {
                    Utils.showError(with: error!, at: self)
                }
            })
        } else {
            Utils.showError(with: "Not all fields were filled", at: self)
        }
    }
    
    @IBAction func singup(_ sender: UIButton) {
        if UIApplication.shared.canOpenURL(signupURL) {
            UIApplication.shared.open(signupURL, options: [:], completionHandler: nil)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

