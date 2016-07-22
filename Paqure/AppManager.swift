//
//  AppManager.swift
//  Paqure
//
//  Created by Linguri Technology on 7/19/16.
//  Copyright © 2016 Digices. All rights reserved.
//

import UIKit

protocol AppManagerDelegate {
    func appObjectSynced(success : Bool)
}

public class AppManager {
    
    public static var sharedInstance : AppManager = AppManager()
    
    var controller : AppManagerDelegate?
    
    var object : App = App()
    
    var source : Source = Source.DEFAULT
    
    let url = NSURL(string: "https://www.digices.com/api/app.php")
    
    // stubs for localization keys
    let v = NSLocalizedString("version", comment: "The version release of the application")
    let c = NSLocalizedString("copyright", comment: "Legal term for copyrighted work")
    let m = NSLocalizedString("loading", comment: "The application is loading")
    let u = NSLocalizedString("update_available", comment: "An update to the application version is available.")
    let r = NSLocalizedString("ready", comment: "The UI is ready to continue")
    let e = NSLocalizedString("error", comment: "An error has occurred")
    
    private init() {
        
        if self.pullFromLocal() == true {
            self.source = Source.LOCAL
        } else {
            self.saveToLocal()
        }
        
        self.pushToRemote()
        
    }
    
    func setController(controller: AppManagerDelegate) {
        self.controller = controller
    }
    
    func pullFromLocal() -> Bool {
        let storedObject = defaults.objectForKey("app")
        if let retrievedObject = storedObject as? NSData {
            if let unarchivedObject = NSKeyedUnarchiver.unarchiveObjectWithData(retrievedObject) {
                if let app = unarchivedObject as? App {
                    self.object = app
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
        
        // initialize parameter to pass to delegate
        var success : Bool = false
        
        if let data = data {
            do {
                let parsedObject = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                if let parsedApp = parsedObject["app"] {
                    if let app = parsedApp as? NSDictionary {
                        let remoteApp = App(dict: app)
                        if remoteApp.id > 0 {
                            self.object = remoteApp
                            self.source = Source.REMOTE
                            success = true
                        }
                    } else {
                        print("object did not evaluate as dictionary")
                    }
                } else {
                    print("key \"app\" does not exist in data")
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
                self.controller?.appObjectSynced(true)
            } else {
                self.controller?.appObjectSynced(false)
            }
        })
        
    }
    
    func saveToLocal() {
        let data = NSKeyedArchiver.archivedDataWithRootObject(self.object)
        defaults.setObject(data, forKey: "app")
        self.source = Source.LOCAL
    }
    
}