//
//  DeviceManager.swift
//  Paqure
//
//  Created by Linguri Technology on 7/21/16.
//  Copyright © 2016 Digices. All rights reserved.
//

import UIKit

protocol DeviceManagerDelegate {
    func deviceObjectSynced(success: Bool)
}

public class DeviceManager {
    
    public static var sharedInstance : DeviceManager = DeviceManager()
    
    var controller : DeviceManagerDelegate?
    
    var object : Device = Device()
        
    var source : Source = Source.DEFAULT
    
    let url = NSURL(string: "https://www.digices.com/api/device.php")

    // stubs for localization keys
    let s = NSLocalizedString("device_settings", comment: "The preferences and settings for the device")

    private init() {
        
        // attempt to replace default device with stored device
        if self.pullFromLocal() == true {
            self.source = Source.LOCAL
        } else {
            self.saveToLocal()
        }
        
        // remote will detect if default condition exists
        self.pushToRemote()
        
    }
    
    func setController(controller: DeviceManagerDelegate) {
        self.controller = controller
    }
    
    func pullFromLocal() -> Bool {
        let storedObject = defaults.objectForKey("device")
        if let retrievedObject = storedObject as? NSData {
            if let unarchivedObject = NSKeyedUnarchiver.unarchiveObjectWithData(retrievedObject) {
                if let device = unarchivedObject as? Device {
                    self.object = device
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
        // create an optional tuple variable to return to
        var success : Bool = false
        
        if let data = data {
            do {
                let parsedObject = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                if let parsedDevice = parsedObject["device"] {
                    if let device = parsedDevice as? NSDictionary {
                        let remoteDevice = Device(dict: device)
                        if remoteDevice.id > 0 {
                            self.object = remoteDevice
                            self.source = Source.REMOTE
                            self.saveToLocal()
                            self.source = Source.SYNCED
                            success = true
                        }
                    } else {
                        print("object did not evaluate")
                    }
                } else {
                    print("key \"device\" does not exist in data")
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
                self.controller?.deviceObjectSynced(true)
            } else {
                self.controller?.deviceObjectSynced(false)
            }
        })
        
    }
    
    func saveToLocal() {
        let data = NSKeyedArchiver.archivedDataWithRootObject(self.object)
        defaults.setObject(data, forKey: "device")
        self.source = Source.LOCAL
    }
    
}