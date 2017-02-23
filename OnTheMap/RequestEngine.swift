//
//  RequestEngine.swift
//  OnTheMap
//
//  Created by Temirlan on 12.02.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class RequestEngine: NSObject {
    
    let api = Constants.ApiMethods.self
    let codes = Constants.StatusCode.self
    
    static let shared = RequestEngine()
    private override init() {}
    
    // MARK: - API Methods
    
    func login(with email: String, password: String, and completion: @escaping(_ loggedIn: Bool, _ error: String?) -> Void) {
        Utils.showIndicator()
        
        let body = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        
        dataTask(of: .post, useEscaping: true, with: api.session, body: body) { (response, error) in
            if let _ = error {
                completion(false, error)
            } else {
                if let dict = response as? [String : AnyObject] {
                    if let session = dict["session"] as? [String : String] {
                        if let id = session["id"] {
                            self.sessionId = id
                        }
                        if let account = dict["account"] as? [String : AnyObject] {
                            if let key = account["key"] as? String {
                                self.uniqueKey = key
                            }
                        }
                    }
                }
                completion(true, nil)
            }
            Utils.removeIndicator()
        }
    }
    
    func logout(with completion: @escaping(_ loggedOut: Bool, _ error: String?) -> Void) {
        Utils.showIndicator()

        dataTask(of: .delete, useEscaping: true, with: api.session, body: nil) { (response, error) in
            if let _ = error {
                completion(false, error)
            } else {
                self.sessionId = nil
                self.uniqueKey = nil
                completion(true, nil)
            }
            Utils.removeIndicator()
        }
    }
    
    func getUserInfo(with completion: @escaping(_ result: [String : AnyObject]?, _ error: String?) -> Void) {
        Utils.showIndicator()
        
        let url = api.userInfo.replacingOccurrences(of: "{uniqueKey}", with: uniqueKey ?? "")
        
        dataTask(of: .get, useEscaping: true, with: url, body: nil) { (response, error) in
            if let _ = error {
                completion(nil, error)
            } else {
                var info = [String: AnyObject]()
                
                if let dict = response as? [String : AnyObject] {
                    if let user = dict["user"] as? [String : AnyObject] {
                        if let firstName = user["first_name"] as? String, let lastName = user["last_name"] as? String {
                            
                            info["firstName"] = firstName as AnyObject?
                            info["lastName"] = lastName as AnyObject?
                        }
                    }
                }

                completion(info, nil)
                Utils.removeIndicator()
            }
        }
    }
    
    func postStudentLocation(student: Student, and completion: @escaping (_ posted: Bool, _ error: String?) -> Void) {
        Utils.showIndicator()
        
        let body = "{\"uniqueKey\": \"\(uniqueKey ?? "")\", \"firstName\": \"\(student.firstName ?? "")\", \"lastName\": \"\(student.lastName ?? "")\",\"mapString\": \"\(student.mapString ?? "")\", \"mediaURL\": \"\(student.mediaUrl ?? "")\",\"latitude\": \(student.location!.x), \"longitude\": \(student.location!.y)}"
        
        dataTask(of: .post, useEscaping: false, with: api.studentLocation, body: body) { (response, error) in
            if let _ = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
            
            Utils.removeIndicator()
        }
    }
    
    func updateStudentLocation(student: Student, and completion: @escaping (_ updated: Bool, _ error: String?) -> Void) {
        Utils.showIndicator()
        
        let body = "{\"uniqueKey\": \"\(uniqueKey ?? "")\", \"firstName\": \"\(student.firstName ?? "")\", \"lastName\": \"\(student.lastName ?? "")\",\"mapString\": \"\(student.mapString ?? "")\", \"mediaURL\": \"\(student.mediaUrl ?? "")\",\"latitude\": \(student.location!.x), \"longitude\": \(student.location!.y)}"
        
        let url = api.studentLocation + "/" + student.objectId!
        
        dataTask(of: .put, useEscaping: false, with: url, body: body) { (response, error) in
            if let _ = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
            
            Utils.removeIndicator()
        }
    }
    
    func studentLocation(with uniqueKey: Bool, and completion: @escaping(_ result: [Student]?, _ error: String?) -> Void) {
        Utils.showIndicator()
        
        let finalUrl = uniqueKey ? api.studentLocation + "?where=%7B%22uniqueKey%22%3A%22\(self.uniqueKey!)%22%7D" : api.studentLocations
        
        dataTask(of: .get, useEscaping: false, with: finalUrl, body: nil) { (response, error) in
            if let _ =  error {
                completion(nil, error)
            } else {
                var studentList = [Student]()
                
                if let result = response as? [String : AnyObject] {
                    if let students = result["results"] as? [[String : AnyObject]] {
                        for studentDict in students {
                            if let student = Student(with: studentDict) {
                                studentList.append(student)
                            }
                        }
                    }
                }
                
                completion(studentList, nil)
            }
            
            Utils.removeIndicator()
        }
    }

    
}

// MARK: - Public properties

extension RequestEngine {
    var uniqueKey: String? {
        set(key) {
            if key != nil {
                UserDefaults.standard.set(key, forKey: Constants.Keys.uniqueKey)
            } else {
                UserDefaults.standard.removeObject(forKey: Constants.Keys.uniqueKey)
            }
        }
        get {
            return UserDefaults.standard.object(forKey: Constants.Keys.uniqueKey) as? String ?? nil
        }
    }
}

// MARK: - Private properties

private extension RequestEngine {
    
    var sessionId: String? {
        set(sId) {
            if sId != nil {
                UserDefaults.standard.set(sId, forKey: Constants.Keys.sessionId)
            } else {
                UserDefaults.standard.removeObject(forKey: Constants.Keys.sessionId)
            }
        }
        get {
            return UserDefaults.standard.object(forKey: Constants.Keys.sessionId) as? String ?? nil
        }
    }
}

// MARK: - Network utils

private extension RequestEngine {
    
    enum MethodType {
        case get, post, put, delete
    }
    
    func dataTask(of type: MethodType, useEscaping: Bool, with url: String, body: String?, completion: @escaping(_ response: AnyObject?, _ error: String?) -> Void) {
        let request = createRequest(type: type, url: url, body: body)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in

            guard (error == nil) else {
                completion(nil, "There was an error with your request")
                return
            }
            
            guard let data = data else {
                completion(nil, "No data was returned by the request!")
                return
            }

            guard let code = (response as? HTTPURLResponse)?.statusCode, self.codes.okRange.contains(code) else {
                var textError = "Not a successfull status code"
                
                let json = self.getError(from: self.properData(from: data))
                if let err = json?["error"] as? String {
                    textError = err
                }
                
                completion(nil, textError)
                return
            }
            
            self.convertData(useEscaping ? self.properData(from: data) : data, completion: completion)
        }
        
        task.resume()
    }
    
    func convertData(_ data: Data, completion: (_ response: AnyObject?, _ error: String?) -> Void) {
        var parsedResult: AnyObject! = nil
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            completion(nil, nil)
        }
        
        completion(parsedResult, nil)
    }
    
    func getError(from data: Data) -> AnyObject? {
        var parsedResult: AnyObject? = nil
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            return nil
        }

        return parsedResult ?? nil
    }
    
    func properData(from data: Data) -> Data {
        return data.subdata(in: Range(uncheckedBounds: (5, data.count)))
    }
    
    // MARK: Creating Requests
    
    func createRequest(type: MethodType, url: String, body: String?) -> NSMutableURLRequest {
        var request: NSMutableURLRequest! = nil
        
        switch type {
        case .delete:
            request = createDeleteRequest(with: url)
        case .post:
            request = createPostRequest(with: url, body: body!)
        case .get:
            request = createGetRequest(with: url)
        case .put:
            request = createPutRequest(with: url, body: body!)
        }
        
        if url.contains("parse") {
            request.addValue(Constants.Parse.appId, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(Constants.Parse.restApi, forHTTPHeaderField: "X-Parse-REST-API-Key")
        }
        
        return request
    }
    
    func createPostRequest(with url: String, body: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: URL(string: url)!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body.data(using: String.Encoding.utf8)
        
        return request
    }
    
    func createPutRequest(with url: String, body: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: URL(string: url)!)
        
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body.data(using: String.Encoding.utf8)
        
        return request
    }
    
    func createDeleteRequest(with url: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: URL(string: url)!)
        
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        return request
    }
    
    func createGetRequest(with url: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: URL(string: url)!)
        return request
    }

}
