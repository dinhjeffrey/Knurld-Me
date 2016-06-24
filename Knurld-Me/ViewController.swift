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
    var accessToken = "TWR7fcMGuxBQzqyotfSmJmKAnP7c"

    override func viewDidLoad() {
        super.viewDidLoad()
        let params = [
            "client_id": "MXUAwA6YvLhQx0pFN35ltPfXE6B1SdTF",
            "client_secret": "RvAhC2QAZV9HAOAm"
        ]
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let url = "https://api.knurld.io/oauth/client_credential/accesstoken?grant_type=client_credentials"
        Alamofire.request(.POST, url, parameters: params, headers: headers)
            .responseJSON { response in
                print(response)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

