//
//  ViewController.swift
//  Knurld-Me
//
//  Created by jeffrey dinh on 6/23/16.
//  Copyright © 2016 jeffrey dinh. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    var audioPath = NSURL()
    
    var json = JSON([])
    typealias url = String
    func encodeJson(url: String, params: [String: AnyObject]) -> [String: AnyObject] {
        var request = NSMutableURLRequest(URL: NSURL(fileURLWithPath: url))
        let encoding = Alamofire.ParameterEncoding.URL
        (request, _) = encoding.encode(request, parameters: params)
        return params
    }
    lazy var headers = [
        "Content-Type": "application/json",
        "Authorization": accessToken,
        "Developer-Id" : developerID
    ]
    static let developerID = "Bearer: eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1MDQ4MTY5MDUsInJvbGUiOiJhZG1pbiIsImlkIjoiZWNkMTAwM2YzODJlNWEzZjU0NGQyZjFkY2Y3YWJhN2IiLCJ0ZW5hbnQiOiJ0ZW5hbnRfbXJwdGF4M25vajJ4b25ic21ydncyNXR1bTV3dGk1ZGdvYnRkaTVsYnBpenc0M2xnb3YzeHMzZHVtcnhkazUzciIsIm5hbWUiOiJhZG1pbiJ9.Vu44NwEq6alluVsEMRdDx5pqn28g0Ju0is1EsYDNPtz06wKwlHoZOi2zv8lvmwqu7RV71oxMizIBqDrcxGKP9g"
    static var accessToken = KnurldRouter.accessToken

    override func viewDidLoad() {
        super.viewDidLoad()
        let params = [
            "client_id": KnurldRouter.clientID,
            "client_secret": KnurldRouter.clientSecret
        ]
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let url = "https://api.knurld.io/oauth/client_credential/accesstoken?grant_type=client_credentials"
        
        Alamofire.request(.POST, url, parameters: params, headers: headers)
            .responseJSON { response in
                
                if let accessToken = response.result.value?["access_token"] as? String {
                    KnurldRouter.accessToken = "Bearer " + accessToken
                    print(KnurldRouter.accessToken)
                }
        }
    }
    
    @IBAction func createAppModel() {
        createAppModel(3, vocabulary: ["Oval", "Circle", "Athens"], verificationLength: 3)
    }
    // change username everytime
    @IBAction func createConsumer() {
        //createConsumer("test14", gender: "M", password: "test")
    }
    @IBAction func createEnrollment() {
        createEnrollment(KnurldRouter.consumerID, application: KnurldRouter.appModelID)
    }
    @IBAction func populateEnrollment() {
        populateEnrollment("https://www.dropbox.com/s/ktudam6wvo5fnff/oval-circle-athens-1x.wav?dl=1", phrase: ["Oval", "Oval", "Oval", "Circle", "Circle", "Circle", "Athens", "Athens", "Athens"], start: [929, 2692, 4792, 6672, 7792, 8832, 11052, 12102, 12962], stop: [1742, 3472, 5532, 7572, 8392, 9582, 11812, 12772, 13772])
    }
    
    @IBAction func createVerification() {
        createVerification(KnurldRouter.consumerID, application: KnurldRouter.appModelID)
    }
    
    @IBAction func verifyVoiceprint() {
        verifyVoiceprint("https://www.dropbox.com/s/ktudam6wvo5fnff/oval-circle-athens-3x.wav?dl=1", phrase: ["Oval", "Circle", "Athens"], start: [929, 2692, 4792], stop: [1742, 3472, 5532])
        verifyVoiceprint("https://www.dropbox.com/s/ktudam6wvo5fnff/oval-circle-athens-3x.wav?dl=1", phrase: ["Oval", "Athens", "Circle"], start: [929, 2692, 4792], stop: [1742, 3472, 5532])
        verifyVoiceprint("https://www.dropbox.com/s/ktudam6wvo5fnff/oval-circle-athens-3x.wav?dl=1", phrase: ["Circle", "Oval", "Athens"], start: [929, 2692, 4792], stop: [1742, 3472, 5532])
        verifyVoiceprint("https://www.dropbox.com/s/ktudam6wvo5fnff/oval-circle-athens-3x.wav?dl=1", phrase: ["Circle", "Athens", "Oval"], start: [929, 2692, 4792], stop: [1742, 3472, 5532])
        verifyVoiceprint("https://www.dropbox.com/s/ktudam6wvo5fnff/oval-circle-athens-3x.wav?dl=1", phrase: ["Athens", "Circle", "Oval"], start: [929, 2692, 4792], stop: [1742, 3472, 5532])
        verifyVoiceprint("https://www.dropbox.com/s/ktudam6wvo5fnff/oval-circle-athens-3x.wav?dl=1", phrase: ["Athens", "Oval", "Circle"], start: [929, 2692, 4792], stop: [1742, 3472, 5532])
    }
    
    @IBAction func initiateCall() {
        initiateCall("12125551212")
    }
    
    @IBAction func terminateCall(sender: UIButton) {
        terminateCall()
    }
    
    @IBAction func analysisUrl() {
        analysisByUrl("https://www.dropbox.com/s/ktudam6wvo5fnff/oval-circle-athens-1x.wav?dl=1", numWords: "3")
    }
    @IBAction func analysisFile() {
//        analysisByFile("/Users/Jeffrey/Library/Developer/CoreSimulator/Devices/FCC00A93-51BB-4A08-9CE9-353B2CA7D53C/data/Containers/Data/Application/28DA96CA-06B8-47A7-9FA0-787B9A354B84/oval-circle-athens-1x.wav", numWords: "3")
        print(RecordVC.)
    }
    
    @IBAction func getAnalysis(sender: UIButton) {
        getAnalysis()
    }
    
    func createAppModel(enrollmentRepeats: Int, vocabulary: [String], verificationLength: Int) {
        let url = "https://api.knurld.io/v1/app-models"
        let params: [String: AnyObject] = [
            "enrollmentRepeats": enrollmentRepeats,
            "vocabulary": vocabulary,
            "verificationLength": verificationLength
        ]

        let encodedParams = encodeJson(url, params: params)
        
        Alamofire.request(.POST, url, parameters: encodedParams, headers: headers, encoding: .JSON)
            .responseJSON { response in
                if let appModelID = response.result.value?["href"] as? String {
                    KnurldRouter.appModelID = appModelID
                    print(KnurldRouter.appModelID)
                }
        }
    }
    
    func createConsumer(name: String, gender: String, password: String){
        let url = "https://api.knurld.io/v1/consumers"
        let params = [
            "username": name,
            "gender": gender,
            "password": password
        ]
        
        let encodedParams = encodeJson(url, params: params)
        
        Alamofire.request(.POST, url, parameters: encodedParams, headers: headers, encoding: .JSON)
            .responseJSON { response in
                if let consumerID = response.result.value?["href"] as? String {
                    KnurldRouter.consumerID = consumerID
                    print(KnurldRouter.consumerID)
                }
        }
    }
    
    func createEnrollment(consumer: url, application: url) {
        let url = "https://api.knurld.io/v1/enrollments/"
        let params = [
            "consumer": consumer,
            "application": application
        ]
        
        let encodedParams = encodeJson(url, params: params)
        
        Alamofire.request(.POST, url, parameters: encodedParams, headers: headers, encoding: .JSON)
            .responseJSON { response in
                if let enrollmentID = response.result.value?["href"] as? String {
                    KnurldRouter.enrollmentID = enrollmentID
                    print(KnurldRouter.enrollmentID)
                }
        }
    }
    
    typealias TimePosition = Int
    struct Interval {
        typealias phrase = String
        typealias start = TimePosition
        typealias stop = TimePosition
    }
    
    func populateEnrollment(audioLink: url,
                            phrase: [Interval.phrase], start: [Interval.start], stop: [Interval.stop] ) {
        let url = KnurldRouter.enrollmentID
        guard url != "" else { print("didn't initiate enrollment yet"); return }
        var intervalsDictionary = [AnyObject]()
        for (index, _) in phrase.enumerate() {
            var intervals = [String: AnyObject]()
            intervals["phrase"] = phrase[index]
            intervals["start"] = start[index]
            intervals["stop"] = stop[index]
            intervalsDictionary.append(intervals)
        }
        
        let params : [String: AnyObject] = [
            "enrollment.wav": audioLink,
            "intervals": intervalsDictionary
        ]
        
        let encodedParams = encodeJson(url, params: params)
        
        Alamofire.request(.POST, url, parameters: encodedParams, headers: headers, encoding: .JSON)
            .responseJSON { response in
                print(KnurldRouter.enrollmentID)
        }
    }
    // wait 10 seconds after populateEnrollment to initiate createVerification
    func createVerification(consumer: url, application: url) {
        let url = "https://api.knurld.io/v1/verifications"
        let params = [
            "consumer": consumer,
            "application": application
        ]
        
        let encodedParams = encodeJson(url, params: params)
        
        Alamofire.request(.POST, url, parameters: encodedParams, headers: headers, encoding: .JSON)
            .responseJSON { response in
                if let verificationID = response.result.value?["href"] as? String {
                    KnurldRouter.verificationID = verificationID
                    print(KnurldRouter.verificationID)
                }
        }
    }
    
    func verifyVoiceprint(audioLink: url,
                          phrase: [Interval.phrase], start: [Interval.start], stop: [Interval.stop] ) {
        let url = KnurldRouter.verificationID
        guard url != "" else { print("didn't initiate verification yet"); return }
        var intervalsDictionary = [AnyObject]()
        for (index, _) in phrase.enumerate() {
            var intervals = [String: AnyObject]()
            intervals["phrase"] = phrase[index]
            intervals["start"] = start[index]
            intervals["stop"] = stop[index]
            intervalsDictionary.append(intervals)
        }
        
        let params : [String: AnyObject] = [
            "verification.wav": audioLink,
            "intervals": intervalsDictionary
        ]
        
        let encodedParams = encodeJson(url, params: params)
        
        Alamofire.request(.POST, url, parameters: encodedParams, headers: headers, encoding: .JSON)
            .responseJSON { response in
                if let verificationID = response.result.value?["href"] as? String {
                    print(verificationID)
                }
        }
    }
    
    func initiateCall(phoneNumber: String) {
        let url = "https://api.knurld.io/v1/calls"
        let params = [
            "number": phoneNumber
        ]

        let encodedParams = encodeJson(url, params: params)
        
        Alamofire.request(.POST, url, parameters: encodedParams, headers: headers, encoding: .JSON)
            .responseJSON { response in
                if let callID = response.result.value?["href"] as? String {
                    KnurldRouter.callID = callID
                    print(KnurldRouter.callID)
                }
        }
    }
    
    func terminateCall() {
        let url = KnurldRouter.callID
        guard url != "" else { print("didn't initiate call yet"); return }
        
        Alamofire.request(.POST, url, headers: headers)
            .responseJSON { response in
                print(response)
        }
    }
    
    func analysisByUrl(audioUrl: url, numWords: String) {
        let url = "https://api.knurld.io/v1/endpointAnalysis/url"
        let params = [
            "audioUrl": audioUrl,
            "words": numWords
        ]
        
        let encodedParams = encodeJson(url, params: params)
        
        Alamofire.request(.POST, url, parameters: encodedParams, headers: headers, encoding: .JSON)
            .responseJSON { response in
                if let taskNameID = response.result.value?["taskName"] as? String {
                    KnurldRouter.taskNameID = taskNameID
                    print(KnurldRouter.taskNameID)
                }
        }
    }
    
    // po NSHomeDirectory()
    // /Users/Jeffrey/Library/Developer/CoreSimulator/Devices/FCC00A93-51BB-4A08-9CE9-353B2CA7D53C/data/Containers/Data/Application/28DA96CA-06B8-47A7-9FA0-787B9A354B84
    
    func analysisByFile(filedata: NSData, numWords: String) {
        let url = "https://api.knurld.io/v1/endpointAnalysis/file"
        let headers = [
            "Authorization": ViewController.accessToken,
            "Developer-Id": ViewController.developerID,
            "Content-Type": "multipart/form-data"
        ]
        let params = [
            "filedata": filedata,
            "num_words": numWords
        ]
        
        Alamofire.request(.POST, url, parameters: params, headers: headers)
            .responseJSON { response in
                print(response)
        }
        
    }
    
    func getAnalysis() {
        let url = "https://api.knurld.io/v1/endpointAnalysis/" + KnurldRouter.taskNameID
        guard KnurldRouter.taskNameID != "" else { print("didn't initiate analysis yet"); return }
        
        Alamofire.request(.GET, url, headers: headers)
            .responseJSON { response in
                if let intervalsJson = response.result.value?["intervals"] as? [AnyObject] {
                    KnurldRouter.intervalsJson = intervalsJson
                    print(KnurldRouter.intervalsJson)
                }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

