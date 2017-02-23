//
//  Constants.swift
//  OnTheMap
//
//  Created by Temirlan on 12.02.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import Foundation

struct Constants {
    
    struct ApiMethods {
        static let session = "https://www.udacity.com/api/session"
        static let userInfo = "https://www.udacity.com/api/users/{uniqueKey}"
        
        static let parseBaseUrl = "https://parse.udacity.com/parse/classes"
        static let studentLocation = ApiMethods.parseBaseUrl + "/StudentLocation"
        static let studentLocations = ApiMethods.parseBaseUrl + "/StudentLocation?limit=100&order=-updatedAt"
    }
    
    struct StatusCode {
        static let okRange = 200...299
        
        static let ok = 200
        
        static let error = -1
        static let noStatusCode = -2
        static let noData = -3
        static let incorrectJSON = -4
    }
    
    struct Parse {
        static let appId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let restApi = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct Keys {
        static let sessionId = "sessionId"
        static let uniqueKey = "uniqueKey"
    }
}
