//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Temirlan on 18.02.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var students: [Student]?
    
    let cellID = "ListCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "PinTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
    
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
    }
    
    func receiveNotification(notification: Notification) {
        if let students = notification.object as? [Student]? {
            self.students = students
            self.tableView.reloadData()
        }
    }

}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! PinTableViewCell
        
        if let student = students?[indexPath.row] {
            cell.nameLabel.text = (student.firstName ?? "") + " " + (student.lastName ?? "")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let student = students?[indexPath.row] {
            if let url = student.mediaUrl, UIApplication.shared.canOpenURL(URL(string: url)!) {
                UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
            } else {
                Utils.showError(with: "Invalid Link", at: self)
            }
        }
    }
    
}
