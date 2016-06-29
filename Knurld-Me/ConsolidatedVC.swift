//
//  ConsolidatedVC.swift
//  Knurld-Me
//
//  Created by Sara Du on 6/29/16.
//  Copyright © 2016 jeffrey dinh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyDropbox

class ConsolidatedVC: UIViewController {
    //sound settings
    var dropboxLink = url()
    var audioPath = NSURL()
    
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    
    let recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),
        AVFormatIDKey : NSNumber(int: Int32(kAudioFormatLinearPCM)),
        AVNumberOfChannelsKey : NSNumber(int: 1),
        AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Medium.rawValue))]
    /////
    
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
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioRecorder = AVAudioRecorder(URL: self.directoryURL()!,
                settings: recordSettings)//初始化实例
            audioRecorder.prepareToRecord()//准备录音
        } catch {
            print("Catching Error")
        }

    }
    
    func performVerificationSequence(){
        createAccessToken()
        
        createAppModel(3, vocabulary: ["Oval", "Circle", "Athens"], verificationLength: 3)

        //creates unique username each time
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyyHHmmss"
        let name = formatter.stringFromDate(currentDateTime)
        createConsumer(name, gender: "M", password: "test")

        createEnrollment(KnurldRouter.consumerID, application: KnurldRouter.appModelID)

        populateEnrollment("https://www.dropbox.com/s/ktudam6wvo5fnff/oval-circle-athens-1x.wav?dl=1", phrase: ["Oval", "Oval", "Oval", "Circle", "Circle", "Circle", "Athens", "Athens", "Athens"], start: [929, 2692, 4792, 6672, 7792, 8832, 11052, 12102, 12962], stop: [1742, 3472, 5532, 7572, 8392, 9582, 11812, 12772, 13772])
        
        createVerification(KnurldRouter.consumerID, application: KnurldRouter.appModelID)
        
        //verify voiceprint
        verifyVoiceprint("https://www.dropbox.com/s/ktudam6wvo5fnff/oval-circle-athens-3x.wav?dl=1", phrase: ["Oval", "Circle", "Athens"], start: [929, 2692, 4792], stop: [1742, 3472, 5532])
        verifyVoiceprint("https://www.dropbox.com/s/ktudam6wvo5fnff/oval-circle-athens-3x.wav?dl=1", phrase: ["Oval", "Athens", "Circle"], start: [929, 2692, 4792], stop: [1742, 3472, 5532])
        verifyVoiceprint("https://www.dropbox.com/s/ktudam6wvo5fnff/oval-circle-athens-3x.wav?dl=1", phrase: ["Circle", "Oval", "Athens"], start: [929, 2692, 4792], stop: [1742, 3472, 5532])
        verifyVoiceprint("https://www.dropbox.com/s/ktudam6wvo5fnff/oval-circle-athens-3x.wav?dl=1", phrase: ["Circle", "Athens", "Oval"], start: [929, 2692, 4792], stop: [1742, 3472, 5532])
        verifyVoiceprint("https://www.dropbox.com/s/ktudam6wvo5fnff/oval-circle-athens-3x.wav?dl=1", phrase: ["Athens", "Circle", "Oval"], start: [929, 2692, 4792], stop: [1742, 3472, 5532])
        verifyVoiceprint("https://www.dropbox.com/s/ktudam6wvo5fnff/oval-circle-athens-3x.wav?dl=1", phrase: ["Athens", "Oval", "Circle"], start: [929, 2692, 4792], stop: [1742, 3472, 5532])

        //initiateCall("12125551212")

        //terminateCall()

        //analysisByUrl(dropboxLink, numWords: "3")

        //analysisByFile(NSData(contentsOfURL: audioPath)!, numWords: "3")
        
        //getAnalysis()

        //uploadAndShare()

    }
  
    //Recording functions
    func directoryURL() -> NSURL? {
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyyHHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        print(recordingName)
        
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.URLByAppendingPathComponent(recordingName)
        return soundURL
    }
    
    @IBAction func startRecord(sender: AnyObject) {
        if !audioRecorder.recording {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(true)
                audioRecorder.record()
                print("record!")
            } catch {
            }
        }
    }
    @IBAction func stopRecord(sender: AnyObject) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setActive(false)
            print("stop!!")
        } catch {
        }
    }
    
    //Knurld functions
    func createAccessToken() {
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
                    print(response)
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
        guard dropboxLink != "" else {print("didn't upload and share wav file to dropbox");return}
        let url = "https://api.knurld.io/v1/endpointAnalysis/url"
        let params = [
            "audioUrl": audioUrl,
            "words": numWords
        ]
        
        let encodedParams = encodeJson(url, params: params)
        
        Alamofire.request(.POST, url, parameters: encodedParams, headers: headers, encoding: .JSON)
            .responseJSON { response in
                print(response)
                if let taskNameID = response.result.value?["taskName"] as? String {
                    KnurldRouter.taskNameID = taskNameID
                    print(KnurldRouter.taskNameID)
                }
        }
    }
    
      
    func analysisByFile(filedata: NSData, numWords: String) {
        let url = "https://api.knurld.io/v1/endpointAnalysis/file"
        let headers = [
            "Authorization": ViewController.accessToken,
            "Developer-Id": ViewController.developerID,
            "Content-Type": "multipart/form-data"
        ]
        //        let params = [
        //            "filedata": filedata,
        //            "num_words": numWords
        //        ]
        
        Alamofire.upload(.POST, url, headers: headers,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: filedata, name: "fileData", fileName: "unicorn.wav", mimeType: "audio/wav")
                //                            multipartFormData.appendBodyPart(data: params["filedata"]!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"filedata")
                //                            multipartFormData.appendBodyPart(data: params["num_words"]!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"num_words")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        print(response)
                        if let taskNameID = response.result.value?["taskName"] as? String {
                            KnurldRouter.taskNameID = taskNameID
                            print(KnurldRouter.taskNameID)
                        }
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }})
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
    
    func uploadAndShare() {
        // Verify user is logged into Dropbox
        if let client = Dropbox.authorizedClient {
            
            // Get the current user's account info
            client.users.getCurrentAccount().response { response, error in
                print("*** Get current account ***")
                if let account = response {
                    print("Hello \(account.name.givenName)!")
                } else {
                    print(error!)
                }
            }
            
            // List folder
            client.files.listFolder(path: "").response { response, error in
                print("*** List folder ***")
                if let result = response {
                    print("Folder contents:")
                    for entry in result.entries {
                        print(entry.name)
                    }
                } else {
                    print(error!)
                }
            }
            
            // Upload a file
            client.files.upload(path: "/recordedAudio.wav", body: NSData(contentsOfURL: audioPath)!).response { response, error in
                if let metadata = response {
                    print("*** Upload file ****")
                    print("Uploaded file name: \(metadata.name)")
                    print("Uploaded file revision: \(metadata.rev)")
                    
                    // Get file (or folder) metadata
                    client.files.getMetadata(path: "/recordedAudio.wav").response { response, error in
                        print("*** Get file metadata ***")
                        if let metadata = response {
                            if let file = metadata as? Files.FileMetadata {
                                print("This is a file with path: \(file.pathLower)")
                                print("File size: \(file.size)")
                            } else if let folder = metadata as? Files.FolderMetadata {
                                print("This is a folder with path: \(folder.pathLower)")
                            }
                        } else {
                            print(error!)
                        }
                    }
                    
                }
            }
        }
        // Sharing
        guard Dropbox.authorizedClient != nil else {print("login first before sharing!");return}
        Dropbox.authorizedClient!.sharing.createSharedLink(path: "/recordedAudio.wav").response({ response, error in
            if let link = response {
                print(link.url)
                self.dropboxLink = link.url
                self.dropboxLink.removeAtIndex(self.dropboxLink.endIndex.advancedBy(-1))
                self.dropboxLink.insert("1", atIndex: self.dropboxLink.endIndex)
                print("dropboxLink is \(self.dropboxLink)")
            } else {
                print(error!)
            }
        })
        
    }

}
