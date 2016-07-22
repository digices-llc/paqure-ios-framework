//
//  LoginManager.swift
//  Paqure
//
//  Created by Linguri Technology on 7/22/16.
//  Copyright © 2016 Digices. All rights reserved.
//

import UIKit

protocol LoginManagerDelegate {
    func authenticationResponse(success: Bool)
}

public class LoginManager {

    public static var sharedInstance : LoginManager = LoginManager()
    
    var controller : LoginManagerDelegate?
    
    let url = NSURL(string: "https://www.digices.com/api/login.php")
    
    var loggedIn : Bool = false
    
    var object : Login = Login()
    
    var source : Source = Source.DEFAULT

    private init() {
        
        // DEBUG
        print("LoginManager.init()")
        
        // attempt to replace default login with stored device
        if self.pullFromLocal() == true {
            // stored login was found
            self.source = Source.LOCAL
        } else {
            // save the default login object to defaults
            self.saveToLocal()
        }
        
    }

    func setController(controller: LoginManagerDelegate) {
        self.controller = controller
    }
    

    func pullFromLocal() -> Bool {
        let storedObject = defaults.objectForKey("login")
        if let retrievedObject = storedObject as? NSData {
            if let unarchivedObject = NSKeyedUnarchiver.unarchiveObjectWithData(retrievedObject) {
                if let login = unarchivedObject as? Login {
                    self.object = login
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func pushToRemote() {
        let request = NSMutableURLRequest(URL: self.url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = self.object.encodedPostBody()
        let task = session.dataTaskWithRequest(request, completionHandler: receiveReply)
        task.resume()
    }
    
    func receiveReply(data : NSData?, response: NSURLResponse?, error: NSError?) {
        
        if let error = error {
            print(error.description)
        }
        
        // initialize parameter to pass to delegate
        var success : Bool = false
        
        if let data = data {
            do {
                let parsedObject = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)

                // part one get the authentication string
                if let parsedAuth = parsedObject["authenticated"] {
                    if let auth = parsedAuth as? String {
                        if auth == "1" {
                            self.object.authenticated = true
                            success = true
                            // transfer the login username and password to user
                            let um = UserManager.sharedInstance
                            um.object.username = self.object.username
                            um.object.password = self.object.password
                        } else {
                            print("authentication was not successful")
                        }
                    } else {
                        print("string did not evaluate")
                    }
                } else {
                    print("key \"authenticated\" does not exist in data")
                }

                // part two update user info
                if success == true {
                    if let parsedStatus = parsedObject["status"] {
                        if let status = parsedStatus as? String {
                            switch status {
                            case "1":
                                print("authorized")
                            case "2":
                                print("readonly")
                            case "3":
                                print("expired")
                            case "4":
                                print("suspended")
                            default:
                                print("default (readonly)")
                            }
                        } else {
                            print("string did not evaluate")
                        }
                    } else {
                        print("key \"status\" does not exist in data")
                    }
                }
                
                // part three get the message
                if let parsedMessage = parsedObject["message"] {
                    if let message = parsedMessage as? String {
                        self.object.message = message
                        success = true
                    } else {
                        print("string did not evaluate")
                    }
                } else {
                    print("key \"user\" does not exist in data")
                }
 
            } catch {
                print("serialization failed")
            }
        } else {
            print("no data received")
        }
        
        NSOperationQueue.mainQueue().addOperationWithBlock({
            if success == true {
                self.source = Source.SYNCED
                self.controller?.authenticationResponse(true)
            } else {
                self.controller?.authenticationResponse(false)
            }
        })
        
    }
    
    func saveToLocal() {
        let data = NSKeyedArchiver.archivedDataWithRootObject(self.object)
        defaults.setObject(data, forKey: "login")
        self.source = Source.LOCAL
    }
    
}