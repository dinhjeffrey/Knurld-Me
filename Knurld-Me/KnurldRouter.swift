//
//  KnurldRouter.swift
//  Knurld-Me
//
//  Created by jeffrey dinh on 6/24/16.
//  Copyright © 2016 jeffrey dinh. All rights reserved.
//

import Foundation
import Alamofire


public enum KnurldRouter: URLRequestConvertible {
    static let baseURLPath = "https://api.knurld.io/v1"
    static let clientID = "MXUAwA6YvLhQx0pFN35ltPfXE6B1SdTF"
    static let clientSecret = "RvAhC2QAZV9HAOAm"
    static let developerID = "Bearer: eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1MDQ4MTY5MDUsInJvbGUiOiJhZG1pbiIsImlkIjoiZWNkMTAwM2YzODJlNWEzZjU0NGQyZjFkY2Y3YWJhN2IiLCJ0ZW5hbnQiOiJ0ZW5hbnRfbXJwdGF4M25vajJ4b25ic21ydncyNXR1bTV3dGk1ZGdvYnRkaTVsYnBpenc0M2xnb3YzeHMzZHVtcnhkazUzciIsIm5hbWUiOiJhZG1pbiJ9.Vu44NwEq6alluVsEMRdDx5pqn28g0Ju0is1EsYDNPtz06wKwlHoZOi2zv8lvmwqu7RV71oxMizIBqDrcxGKP9g"
    static var accessToken = String()
    static var enrollmentID = String()
    
    case CreateConsumer(String, String, String)
    case CreateEnrollment(String, String)
    case PopulateEnrollment(String, String, Int, Int, Int, Int, Int, Int,
        String, Int, Int, Int, Int, Int, Int,
        String, Int, Int, Int, Int, Int, Int )
    
    public var URLRequest: NSMutableURLRequest {
        let result: (path: String, method: Alamofire.Method, parameters: [String: AnyObject]) = {
            switch self {
            case let .CreateConsumer(username, gender, password):
                let params = ["username": username, "gender": gender, "password": password]
                return("/consumers", .POST, params)
            case let .CreateEnrollment(consumer, application):
                let params = ["consumer": consumer, "application": application]
                return("/enrollments", .POST, params)
            case let .PopulateEnrollment(audioURL, phrase1, start1, stop1, start2, stop2, start3, stop3, phrase2, start4, stop4, start5, stop5, start6, stop6, phrase3, start7, stop7, start8, stop8, start9, stop9):
                let intervals =
                [
                    ["phrase": phrase1,
                    "start": start1,
                    "stop": stop1
                    ],
                    ["phrase": phrase1,
                    "start": start2,
                    "stop": stop2
                    ],
                    ["phrase": phrase1,
                    "start": start3,
                    "stop": stop3
                    ],
                    ["phrase": phrase2,
                    "start": start4,
                    "stop": stop4
                    ],
                    ["phrase": phrase2,
                    "start": start5,
                    "stop": stop5
                    ],
                    ["phrase": phrase2,
                    "start": start6,
                    "stop": stop6
                    ],
                    ["phrase": phrase3,
                    "start": start7,
                    "stop": stop7
                    ],
                    ["phrase": phrase3,
                    "start": start8,
                    "stop": stop8
                    ],
                    ["phrase": phrase3,
                    "start": start9,
                    "stop": stop9
                    ]
                ]
                let params = ["enrollment.wav": audioURL, "intervals": intervals]
                return(KnurldRouter.enrollmentID.substringFromIndex(KnurldRouter.enrollmentID.startIndex.advancedBy(24)), .POST, params as! [String : AnyObject])
            }
        }()
        
        let URL = NSURL(string: KnurldRouter.baseURLPath)!
        let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
        URLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLRequest.HTTPMethod = result.method.rawValue
        URLRequest.setValue(KnurldRouter.accessToken, forHTTPHeaderField: "Authorization")
        URLRequest.setValue(KnurldRouter.developerID, forHTTPHeaderField: "Developer-Id")
        URLRequest.timeoutInterval = NSTimeInterval(10 * 1000)
        
        switch self {
        case .CreateConsumer(_, _, _):
            return Alamofire.ParameterEncoding.JSON.encode(URLRequest, parameters: result.parameters).0
        case .CreateEnrollment(_, _):
            return Alamofire.ParameterEncoding.JSON.encode(URLRequest, parameters: result.parameters).0
        case.PopulateEnrollment(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _):
            return Alamofire.ParameterEncoding.JSON.encode(URLRequest, parameters: result.parameters).0
        }
    }
    
}
