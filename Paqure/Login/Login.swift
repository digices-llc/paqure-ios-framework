//
//  Login.swift
//  Paqure
//
//  Created by Linguri Technology on 7/22/16.
//  Copyright © 2016 Digices. All rights reserved.
//

import UIKit

class Login: NSObject, NSCoding {
    
    var username: NSString
    var password: NSString
    var submit : NSString
    var forgot : NSString
    var signup : NSString
    var message: NSString
    var authenticated : Bool
    
    override init() {
        self.username = "anonymous"
        self.password = "none"
        self.submit = NSLocalizedString("log_in", comment: "Sign in or log in to account")
        self.forgot = NSLocalizedString("forgot", comment: "Forgot username or password")
        self.signup = NSLocalizedString("signup", comment: "Sign up for new account")
        self.message = " "
        self.authenticated = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.username = aDecoder.decodeObjectForKey("username") as! NSString
        self.password = aDecoder.decodeObjectForKey("password") as! NSString
        self.submit = aDecoder.decodeObjectForKey("submit") as! NSString
        self.forgot = aDecoder.decodeObjectForKey("forgot") as! NSString
        self.signup = aDecoder.decodeObjectForKey("signup") as! NSString
        self.message = aDecoder.decodeObjectForKey("message") as! NSString
        self.authenticated = aDecoder.decodeBoolForKey("authenticated")
    }
    
    init(dict: NSDictionary) {
        
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
        
        if let authenticated = dict["authenticated"] as? String {
            if authenticated == "1" {
                self.authenticated = true
            } else {
                self.authenticated = false
            }
        } else {
            self.authenticated = false
        }
        
        self.submit = "log_in"
        
        self.forgot = "forgot"
        
        self.signup = "signup"
        
        self.message = " "
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.username, forKey: "username")
        aCoder.encodeObject(self.password, forKey: "password")
        aCoder.encodeObject(self.submit, forKey: "submit")
        aCoder.encodeObject(self.forgot, forKey: "forgot")
        aCoder.encodeObject(self.signup, forKey: "signup")
        aCoder.encodeObject(self.message, forKey: "message")
        aCoder.encodeBool(self.authenticated, forKey: "authenticated")
    }
    
    func encodedPostBody() -> NSData {
        let body = self.getSuffix()
        print(body)
        return body.dataUsingEncoding(NSUTF8StringEncoding)! as NSData
    }
    
    func getSuffix() -> String {
        return "username=\(self.username)&password=\(self.password)"
    }
    
}
