//
//  User.swift
//  Paqure
//
//  Created by Linguri Technology on 7/21/16.
//  Copyright © 2016 Digices. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var id : Int
    var username: NSString
    var password: NSString
    var email : NSString
    var first : NSString
    var last : NSString
    var age : Int
    var status : Int
    
    override init() {
        self.id = 2
        self.username = "anonymous"
        self.password = "none"
        self.email = "anonymous@digices.com"
        self.first = "Anonymous"
        self.last = "User"
        self.age = 99
        self.status = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeIntegerForKey("id")
        self.username = aDecoder.decodeObjectForKey("username") as! NSString
        self.password = aDecoder.decodeObjectForKey("password") as! NSString
        self.email = aDecoder.decodeObjectForKey("email") as! NSString
        self.first = aDecoder.decodeObjectForKey("first") as! NSString
        self.last = aDecoder.decodeObjectForKey("last") as! NSString
        self.age = aDecoder.decodeIntegerForKey("age")
        self.status = aDecoder.decodeIntegerForKey("status")
    }
    
    init(dict: NSDictionary) {
        
        // JSON object converts to [String:String]
        if let id = dict["id"] as? String {
            if let idInt = Int(id) {
                self.id = idInt
            } else {
                self.id = 2
            }
        } else {
            self.id = 2
        }
        
        if let username = dict["username"] as? String {
            self.username = username
        } else {
            self.username = "anonymous"
        }
        
        if let password = dict["password"] as? String {
            self.password = password
        } else {
            self.password = "none"
        }
        
        if let email = dict["email"] as? String {
            self.email = email
        } else {
            self.email = "anonymous@digices.com"
        }
        
        if let first = dict["first"] as? String {
            self.first = first
        } else {
            self.first = "Anonymous"
        }
        
        if let last = dict["last"] as? String {
            self.last = last
        } else {
            self.last = "User"
        }
        
        if let age = dict["age"] as? String {
            if let ageInt = Int(age) {
                self.age = ageInt
            } else {
                self.age = 0
            }
        } else {
            self.age = 0
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
        aCoder.encodeObject(self.username, forKey: "username")
        aCoder.encodeObject(self.password, forKey: "password")
        aCoder.encodeObject(self.email, forKey: "email")
        aCoder.encodeObject(self.first, forKey: "first")
        aCoder.encodeObject(self.last, forKey: "last")
        aCoder.encodeInteger(self.age, forKey: "age")
        aCoder.encodeInteger(self.status, forKey: "status")
    }
    
    func encodedPostBody() -> NSData {
        let body = self.getSuffix()
        print(body)
        return body.dataUsingEncoding(NSUTF8StringEncoding)! as NSData
    }
    
    func getSuffix() -> String {
        return "id=\(self.id)&username=\(self.username)&password=\(self.password)&email=\(self.email)&first=\(self.first)&last=\(self.last)&age=\(self.age)&status=\(self.status)"
    }
    
}