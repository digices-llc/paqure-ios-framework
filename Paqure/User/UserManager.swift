//
//  UserManager.swift
//  Paqure
//
//  Created by Linguri Technology on 7/21/16.
//  Copyright © 2016 Digices. All rights reserved.
//

import UIKit

protocol UserManagerDelegate {
    func userObjectSynced(success: Bool)
}

public class UserManager {
    
    public static var sharedInstance : UserManager = UserManager()
    
    var controller : UserManagerDelegate?
    
    var object : User = User()
    
    // var collection : [User] = []
    
    var source : Source = Source.DEFAULT
    
    let url = NSURL(string: "https://www.digices.com/api/user.php")
    
    private init() {
        
        if self.pullFromLocal() == true {
            self.source = Source.LOCAL
        } else {
            self.saveToLocal()
        }
        
        self.pushToRemote()
        
    }
    
    func setController(controller: UserManagerDelegate) {
        self.controller = controller
    }
    
    func pullFromLocal() -> Bool {
        let storedObject = defaults.objectForKey("user")
        if let retrievedObject = storedObject as? NSData {
            if let unarchivedObject = NSKeyedUnarchiver.unarchiveObjectWithData(retrievedObject) {
                if let user = unarchivedObject as? User {
                    self.object = user
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
        
        if let response = response {
            print("\(response)")
        }
        
        // create an optional tuple variable to return to
        var success : Bool = false
        
        
        
        if let data = data {
            do {
                let parsedObject = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                if let parsedUser = parsedObject["user"] {
                    if let user = parsedUser as? NSDictionary {
                        let remoteUser = User(dict: user)
                        if remoteUser.id > 0 {
                            self.object = remoteUser
                            self.source = Source.REMOTE
                            self.saveToLocal()
                            self.source = Source.SYNCED
                            success = true
                        }
                    } else {
                        print("object did not evaluate")
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
                self.controller?.userObjectSynced(true)
            } else {
                self.controller?.userObjectSynced(false)
            }
        })
        
    }
    
    func saveToLocal() {
        let data = NSKeyedArchiver.archivedDataWithRootObject(self.object)
        defaults.setObject(data, forKey: "user")
        self.source = Source.LOCAL
    }
    
}