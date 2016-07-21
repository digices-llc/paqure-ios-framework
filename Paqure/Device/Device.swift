//
//  Device.swift
//  Paqure
//
//  Created by Linguri Technology on 7/21/16.
//  Copyright © 2016 Digices. All rights reserved.
//

import UIKit

class Device: NSObject {
    
    var id : Int
    var label: NSString
    var identifier: NSString
    var locale : NSString
    var token : NSString
    var created : Int
    var modified : Int
    var status : Int
    
    override init() {
        self.id = 2
        self.label = ""
        self.identifier = UIDevice.currentDevice().identifierForVendor!.UUIDString
        self.locale = NSLocale.currentLocale().localeIdentifier
        self.token = "4c9184f37cff01bcdc32dc486ec36961"
        self.created = Int(NSTimeInterval(NSTimeIntervalSince1970))
        self.modified = Int(NSTimeInterval(NSTimeIntervalSince1970))
        self.status = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeIntegerForKey("id")
        self.label = aDecoder.decodeObjectForKey("label") as! NSString
        self.identifier = aDecoder.decodeObjectForKey("identifier") as! NSString
        self.locale = aDecoder.decodeObjectForKey("locale") as! NSString
        self.token = aDecoder.decodeObjectForKey("token") as! NSString
        self.created = aDecoder.decodeIntegerForKey("created")
        self.modified = aDecoder.decodeIntegerForKey("modified")
        self.status = aDecoder.decodeIntegerForKey("status")
    }
    
    init(dict: NSDictionary) {
        
        // JSON Dictionary returns strings, which will prevent casting to device, so we must convert
        if let id = dict["id"] as? String {
            if let idInt = Int(id) {
                self.id = idInt
            } else {
                self.id = 0
            }
        } else {
            self.id = 0
        }
        
        if let label = dict["label"] as? String {
            self.label = label
        } else {
            self.label = ""
        }
        
        if let identifier = dict["identifier"] as? String {
            self.identifier = identifier
        } else {
            self.identifier = UIDevice.currentDevice().identifierForVendor!.UUIDString
        }
        
        if let locale = dict["locale"] as? String {
            self.locale = locale
        } else {
            self.locale = NSLocale.currentLocale().localeIdentifier
        }
        
        if let token = dict["token"] as? String {
            self.token = token
        } else {
            self.token = ""
        }
        
        if let created = dict["created"] as? String {
            if let createdInt = Int(created) {
                self.created = createdInt
            } else {
                self.created = 0
            }
        } else {
            self.created = 0
        }
        
        if let modified = dict["modified"] as? String {
            if let modifiedInt = Int(modified) {
                self.modified = modifiedInt
            } else {
                self.modified = 0
            }
        } else {
            self.modified = 0
        }
        
        if let status = dict["status"] as? String {
            if let statusInt = Int(status) {
                self.status = statusInt
            } else {
                self.status = 2
            }
        } else {
            self.status = 2
        }
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(self.id, forKey: "id")
        aCoder.encodeObject(self.label, forKey: "label")
        aCoder.encodeObject(self.identifier, forKey: "identifier")
        aCoder.encodeObject(self.locale, forKey: "locale")
        aCoder.encodeObject(self.token, forKey: "token")
        aCoder.encodeInteger(self.created, forKey: "created")
        aCoder.encodeInteger(self.modified, forKey: "modified")
        aCoder.encodeInteger(self.status, forKey: "status")
    }
    
    func encodedPostBody() -> NSData {
        let body = self.getSuffix()
        return body.dataUsingEncoding(NSUTF8StringEncoding)! as NSData
    }
    
    func getSuffix() -> String {
        return "id=\(self.id)&label=\(self.label)&identifier=\(self.identifier)&locale=\(self.locale)&token=\(self.token)&created=\(self.created)&modified=\(self.modified)&status=\(self.status)"
    }
    
}
