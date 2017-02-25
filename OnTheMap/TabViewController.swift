//
//  TabViewController.swift
//  OnTheMap
//
//  Created by Temirlan on 19.02.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {
    
    let segue = "AddLocation"
    var me: Student? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudents(with: false)
    }

    @IBAction func logout(_ sender: Any) {
        RequestEngine.shared.logout { (loggedOut, err) in
            if loggedOut {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                Utils.showError(with: err ?? "Unknown error", at: self)
            }
        }
    }
    
    @IBAction func refersh(_ sender: Any) {
        getStudents(with: false)
    }
    
    @IBAction func addLocation(_ sender: Any) {
        if let _ = me {
            let alert = UIAlertController(title: "", message: "User \"\(me!.firstName + " " + me!.lastName)\" Has Already Posted a Student Location. Would You Like to Overwrite Their Location?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                alert.dismiss(animated: true, completion: nil)
            })
            
            alert.addAction(UIAlertAction(title: "Overwrite", style: .default) { (action) in
                self.performSegue(withIdentifier: self.segue, sender: self.me!)
            })
            
            present(alert, animated: true, completion: nil)
        } else {
            getStudents(with: true)
            self.performSegue(withIdentifier: segue, sender: self.me ?? nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segue {
            let navController = segue.destination as! UINavigationController
            let vc = navController.topViewController as! PostLocationViewController
            vc.me = sender as? Student
        }
    }
    
    func getStudents(with uniqueKey: Bool) {
        view.isUserInteractionEnabled = false
        
        RequestEngine.shared.studentLocation(with: uniqueKey) { (students, error) in
            if let _ = error {
                Utils.showError(with: error!, at: self)
            } else {
                if let _ = students {
                    DispatchQueue.main.async {
                        for student in students! {
                            if let key = student.uniqueKey, key == RequestEngine.shared.uniqueKey {
                                self.me = student
                            }
                        }
                        
                        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
}
