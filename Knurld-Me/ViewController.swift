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
                
                if let accessToken = response.result.value?["access_token"] {
                    KnurldRouter.accessToken = "Bearer " + (accessToken as! String)
                    print(KnurldRouter.accessToken)
                }
        }
    }
    
    @IBAction func createConsumer() {
        createConsumer("YoureCute", gender: "M", password: "YoureCute")
    }
    @IBAction func createEnrollment() {
        createEnrollment("https://api.knurld.io/v1/consumers/ecd1003f382e5a3f544d2f1dcf7afa33", application: "https://api.knurld.io/v1/app-models/ecd1003f382e5a3f544d2f1dcf7af492")
    }
    @IBAction func populateEnrollment() {
        populateEnrollment("https://www.dropbox.com/s/pxldjp3r3ppm3qs/audio_recording_audioInputwav%20%281%29.wav?dl=1", phrase1: "Canada", start1: 929, stop1: 1742, start2: 2692, stop2: 3472, start3: 4792, stop3: 5532, phrase2: "Canada", start4: 6672, stop4: 7572, start5: 7792, stop5: 8392, start6: 8832, stop6: 9582, phrase3: "Circle", start7: 11052, stop7: 11812, start8: 12102, stop8: 12772, start9: 12962, stop9: 13772)
    }
    
    func createConsumer(name: String, gender: String, password: String){
        Alamofire.request(KnurldRouter.CreateConsumer(name, gender, password))
            .responseJSON { response in
                print(response)
        }
    }
    
    func createEnrollment(consumer: String, application: String) {
        Alamofire.request(KnurldRouter.CreateEnrollment(consumer, application))
            .responseJSON { response in
                if let enrollmentID = response.result.value?["href"] {
                    KnurldRouter.enrollmentID = enrollmentID as! String
                }
                print(response)
        }
    }
    
    func populateEnrollment(audioLink: String,
                            phrase1: String, start1: Int, stop1: Int, start2: Int, stop2: Int, start3: Int, stop3: Int,
                            phrase2: String, start4: Int, stop4: Int, start5: Int, stop5: Int, start6: Int, stop6: Int,
                            phrase3: String, start7: Int, stop7: Int, start8: Int, stop8: Int, start9: Int, stop9: Int ) {
        Alamofire.request(KnurldRouter.PopulateEnrollment(audioLink, phrase1, start1, stop1, start2, stop2, start3, stop3, phrase2, start4, stop4, start5, stop5, start6, stop6, phrase3, start7, stop7, start8, stop8, start9, stop9))
            .responseJSON { response in
                print(response)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

