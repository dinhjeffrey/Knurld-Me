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
    var json = JSON([])
    typealias url = String
    
    
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
    
    @IBAction func analysis() {
        analysisByUrl("https://www.dropbox.com/s/ktudam6wvo5fnff/oval-circle-athens-1x.wav?dl=1", numWords: "3")
    }
    
    @IBAction func getAnalysis(sender: UIButton) {
        getAnalysis()
    }
    
    func createAppModel(enrollmentRepeats: Int, vocabulary: [String], verificationLength: Int) {
        let url = "https://api.knurld.io/v1/app-models"
        let params = [
            "enrollmentRepeats": enrollmentRepeats,
            "vocabulary": vocabulary,
            "verificationLength": verificationLength
        ]
        let headers = [
            "Content-Type": "application/json",
            "Authorization": KnurldRouter.accessToken,
            "Developer-Id" : KnurldRouter.developerID
        ]
        
        var request = NSMutableURLRequest(URL: NSURL(fileURLWithPath: url))
        let encoding = Alamofire.ParameterEncoding.URL
        (request, _) = encoding.encode(request, parameters: params as? [String : AnyObject])
        
        Alamofire.request(.POST, url, parameters: params as? [String : AnyObject], headers: headers, encoding: .JSON)
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
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": KnurldRouter.accessToken,
            "Developer-Id" : KnurldRouter.developerID
        ]
        
        var request = NSMutableURLRequest(URL: NSURL(fileURLWithPath: url))
        let encoding = Alamofire.ParameterEncoding.URL
        (request, _) = encoding.encode(request, parameters: params)
        
        Alamofire.request(.POST, url, parameters: params, headers: headers, encoding: .JSON)
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
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": KnurldRouter.accessToken,
            "Developer-Id" : KnurldRouter.developerID
        ]
        
        var request = NSMutableURLRequest(URL: NSURL(fileURLWithPath: url))
        let encoding = Alamofire.ParameterEncoding.URL
        (request, _) = encoding.encode(request, parameters: params)
        
        
        Alamofire.request(.POST, url, parameters: params, headers: headers, encoding: .JSON)
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
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization":  KnurldRouter.accessToken,
            "Developer-Id" : KnurldRouter.developerID
        ]
        
        
        var request = NSMutableURLRequest(URL: NSURL(fileURLWithPath: url))
        let encoding = Alamofire.ParameterEncoding.URL
        (request, _) = encoding.encode(request, parameters: params)
        
        
        Alamofire.request(.POST, url, parameters: params, headers: headers, encoding: .JSON)
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
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": KnurldRouter.accessToken,
            "Developer-Id" : KnurldRouter.developerID
        ]
        
        var request = NSMutableURLRequest(URL: NSURL(fileURLWithPath: url))
        let encoding = Alamofire.ParameterEncoding.URL
        (request, _) = encoding.encode(request, parameters: params)
        
        
        Alamofire.request(.POST, url, parameters: params, headers: headers, encoding: .JSON)
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
        _ = {
            for (index, _) in phrase.enumerate() {
                var intervals = [String: AnyObject]()
                intervals["phrase"] = phrase[index]
                intervals["start"] = start[index]
                intervals["stop"] = stop[index]
                intervalsDictionary.append(intervals)
            }
        }()
        
        let params : [String: AnyObject] = [
            "verification.wav": audioLink,
            "intervals": intervalsDictionary
        ]
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization":  KnurldRouter.accessToken,
            "Developer-Id" : KnurldRouter.developerID
        ]
        
        var request = NSMutableURLRequest(URL: NSURL(fileURLWithPath: url))
        let encoding = Alamofire.ParameterEncoding.URL
        (request, _) = encoding.encode(request, parameters: params)
        
        
        Alamofire.request(.POST, url, parameters: params, headers: headers, encoding: .JSON)
            .responseJSON { response in
                print(response)
        }
    }
    
    func initiateCall(phoneNumber: String) {
        let url = "https://api.knurld.io/v1/calls"
        let params = [
            "number": phoneNumber
        ]
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": KnurldRouter.accessToken,
            "Developer-Id" : KnurldRouter.developerID
        ]
        
        var request = NSMutableURLRequest(URL: NSURL(fileURLWithPath: url))
        let encoding = Alamofire.ParameterEncoding.URL
        (request, _) = encoding.encode(request, parameters: params)
        
        Alamofire.request(.POST, url, parameters: params, headers: headers, encoding: .JSON)
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
        let headers = [
            "Content-Type": "application/json",
            "Authorization": KnurldRouter.accessToken,
            "Developer-Id" : KnurldRouter.developerID
        ]
        
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
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": KnurldRouter.accessToken,
            "Developer-Id" : KnurldRouter.developerID
        ]
        
        var request = NSMutableURLRequest(URL: NSURL(fileURLWithPath: url))
        let encoding = Alamofire.ParameterEncoding.URL
        (request, _) = encoding.encode(request, parameters: params)
        
        Alamofire.request(.POST, url, parameters: params, headers: headers, encoding: .JSON)
            .responseJSON { response in
                if let taskNameID = response.result.value?["taskName"] as? String {
                    KnurldRouter.taskNameID = taskNameID
                    print(KnurldRouter.taskNameID)
                }
        }
    }
    
    func getAnalysis() {
        let url = "https://api.knurld.io/v1/endpointAnalysis/" + KnurldRouter.taskNameID
        guard KnurldRouter.taskNameID != "" else { print("didn't initiate analysis yet"); return }
        let headers = [
            "Authorization": KnurldRouter.accessToken,
            "Developer-Id" : KnurldRouter.developerID
        ]
        
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

