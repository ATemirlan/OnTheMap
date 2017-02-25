//
//  StudentsHolder.swift
//  OnTheMap
//
//  Created by Temirlan on 25.02.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

private let _documentsDirectoryURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
private let _fileURL: URL = _documentsDirectoryURL.appendingPathComponent("Students")

class StudentsHolder: NSObject, NSCoding {

    var students: [Student]
    
    init(students: [Student]) {
        self.students = students
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.students = aDecoder.decodeObject(forKey: "studentHolder") as! [Student]
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(students, forKey: "studentHolder")
    }
    
    func saveStudents() -> Bool {
        return NSKeyedArchiver.archiveRootObject(self, toFile: _fileURL.path)
    }
    
    class func getStudentHolder() -> StudentsHolder? {
        if FileManager.default.fileExists(atPath: _fileURL.path) {
            if let obj = NSKeyedUnarchiver.unarchiveObject(withFile: _fileURL.path) as? StudentsHolder {
                return obj
            }
            return nil
        } else {
            return nil
        }
    }
    
}
