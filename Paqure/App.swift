//
//  App.swift
//  Paqure
//
//  Created by Linguri Technology on 7/19/16.
//  Copyright © 2016 Digices. All rights reserved.
//

import UIKit

class App: NSObject, NSCoding {
    
    // object properties
    var id : Int
    var name: NSString
    var major : Int
    var minor : Int
    var fix : Int
    var copyright : Int
    var company: NSString
    var update : Int
    
    // initialize in default state
    override init() {
        self.id = 2
        self.name = NSLocalizedString("app_name", comment: "Title representing the public name of the app")
        self.major = 0
        self.minor = 0
        self.fix = 1
        self.copyright = 2016
        self.company = "Digices, LLC"
        self.update = 0
    }
    
    // initialize in default state
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeIntegerForKey("id")
        self.name = aDecoder.decodeObjectForKey("name") as! NSString
        self.major = aDecoder.decodeIntegerForKey("major")
        self.minor = aDecoder.decodeIntegerForKey("minor")
        self.fix = aDecoder.decodeIntegerForKey("fix")
        self.copyright = aDecoder.decodeIntegerForKey("copyright")
        self.company = aDecoder.decodeObjectForKey("company") as! NSString
        self.update = aDecoder.decodeIntegerForKey("update")
    }
    
    // initialize with a [String:String] dictionary
    init(dict: NSDictionary) {
        
        if let id = dict["id"] as? String {
            if let idInt = Int(id) {
                self.id = idInt
            } else {
                self.id = 0
            }
        } else {
            self.id = 0
        }
        
        if let name = dict["name"] as? String {
            self.name = name
        } else {
            self.name = ""
        }
        
        if let major = dict["major"] as? String {
            if let majorInt = Int(major) {
                self.major = majorInt
            } else {
                self.major = 0
            }
        } else {
            self.major = 0
        }
        
        if let minor = dict["minor"] as? String {
            if let minorInt = Int(minor) {
                self.minor = minorInt
            } else {
                self.minor = 0
            }
        } else {
            self.minor = 0
        }
        
        if let fix = dict["fix"] as? String {
            if let fixInt = Int(fix) {
                self.fix = fixInt
            } else {
                self.fix = 0
            }
        } else {
            self.fix = 0
        }
        
        if let copyright = dict["copyright"] as? String {
            if let copyrightInt = Int(copyright) {
                self.copyright = copyrightInt
            } else {
                self.copyright = 0
            }
        } else {
            self.copyright = 0
        }
        
        if let company = dict["company"] as? String {
            self.company = company
        } else {
            self.company = ""
        }
        
        if let update = dict["update"] as? String {
            if let updateInt = Int(update) {
                self.update = updateInt
            } else {
                self.update = 0
            }
        } else {
            self.update = 0
        }
        
    }
    
    // NSCoding compliance when saving objects
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(self.id, forKey: "id")
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeInteger(self.major, forKey: "major")
        aCoder.encodeInteger(self.minor, forKey: "minor")
        aCoder.encodeInteger(self.fix, forKey: "fix")
        aCoder.encodeInteger(self.copyright, forKey: "copyright")
        aCoder.encodeObject(self.company, forKey: "company")
        aCoder.encodeInteger(self.update, forKey: "update")
    }
    
    // a tap to enable appending an HTTP GET string to a URL
    func getSuffix() -> String {
        return "id=\(self.id)&name=\(self.name)&major=\(self.major)&minor=\(self.minor)&fix=\(self.fix)&copyright=\(self.copyright)&company=\(self.company)&update=\(self.update)"
    }
    
    // return NSURLSession compliant HTTP Body header for object
    func encodedPostBody() -> NSData {
        let body = self.getSuffix()
        return body.dataUsingEncoding(NSUTF8StringEncoding)! as NSData
    }
    
}
