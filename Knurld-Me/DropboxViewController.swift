//
//  DropboxViewController.swift
//  Knurld-Me
//
//  Created by jeffrey dinh on 6/29/16.
//  Copyright © 2016 jeffrey dinh. All rights reserved.
//

import UIKit
import SwiftyDropbox

class DropboxViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func linkButtonPressed(sender: UIButton) {
        guard Dropbox.authorizedClient == nil else {print("already logged into dropbox");return}
        Dropbox.authorizeFromController(self)
    }
    @IBAction func logoutButtonPressed(sender: UIButton) {
        logout()
        
    }
    
    @IBAction func dropboxStuffPressed() {
       uploadToDropbox()
    }
    
    @IBAction func sharePressed(sender: UIButton) {
       shareLink()
    }
    
    func logout() {
        // Clear the app group of all files
        if let containerURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.com.Dropbox.DropboxPhotoWatch") {
            
            // Fetch all files in the app group
            do {
                let fileURLArray = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(containerURL, includingPropertiesForKeys: [NSURLNameKey], options: [])
                
                for fileURL in fileURLArray {
                    // Check that file is a photo (by file extension)
                    if fileURL.absoluteString.hasSuffix(".jpg") || fileURL.absoluteString.hasSuffix(".png") {
                        
                        do {
                            // Delete the photo from the app group
                            try NSFileManager.defaultManager().removeItemAtURL(fileURL)
                        } catch _ as NSError {
                            // Do nothing with the error
                        }
                    }
                }
            } catch _ as NSError {
                // Do nothing with the error
            }
            
        }
        
        // Unlink from Dropbox
        Dropbox.unlinkClient()
        
        // Dismiss view controller to show login screen
        self.dismissViewControllerAnimated(true, completion: nil)
        print("logged out of dropbox")
        
    }
    func uploadToDropbox() {
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
            let fileData = "Hello!".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            client.files.upload(path: "/hello.txt", body: fileData!).response { response, error in
                if let metadata = response {
                    print("*** Upload file ****")
                    print("Uploaded file name: \(metadata.name)")
                    print("Uploaded file revision: \(metadata.rev)")
                    
                    // Get file (or folder) metadata
                    client.files.getMetadata(path: "/hello.txt").response { response, error in
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
    }
    
    func shareLink() {
        guard Dropbox.authorizedClient != nil else {print("login first before sharing!");return}
        Dropbox.authorizedClient!.sharing.createSharedLink(path: "/hello.txt").response({ response, error in
            if let link = response {
                print(link.url)
            } else {
                print(error!)
            }
        })
    }
    
}
