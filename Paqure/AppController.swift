//
//  AppController.swift
//  Paqure
//
//  Created by Linguri Technology on 7/19/16.
//  Copyright © 2016 Digices. All rights reserved.
//

import UIKit

class AppController: UIViewController, AppManagerDelegate, DeviceManagerDelegate, UserManagerDelegate, LoginManagerDelegate {

    let am : AppManager = AppManager.sharedInstance
    let dm : DeviceManager = DeviceManager.sharedInstance
    let um : UserManager = UserManager.sharedInstance
    let lm : LoginManager = LoginManager.sharedInstance
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var copyrightLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TEMP set up title and state for temp button (this will eventually become automatic)
        self.continueButton.setTitle(NSLocalizedString("continue", comment: "Continue to next screen."), forState: .Normal)
        
        // TEMP disable the button until we're loaded
        self.continueButton.userInteractionEnabled = false
        
        // set ourselves as the delegate for the setup managers
        self.am.setController(self)
        self.dm.setController(self)
        self.um.setController(self)
        self.lm.setController(self)
        
        // set user interace to default elements
        self.updateUI()
        
    }

    // updates interface elements in the AppView (startup screen)
    func updateUI() {
        self.messageLabel.text = self.am.m
        self.nameLabel.text = self.am.object.name as String
        self.versionLabel.text = "\(self.am.v) \(self.am.object.major).\(self.am.object.minor).\(self.am.object.fix)"
        self.copyrightLabel.text = "\(self.am.c) \(self.am.object.copyright) \(self.am.object.company)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTouchContinue(sender: AnyObject) {
        // segue to user to test
        // MOVE THIS TO AUTHENTICATION RESPONSE
        // self.performSegueWithIdentifier("showSettings", sender: self)
    }

    func appObjectSynced(success : Bool) {
        if success == true {
            if self.am.object.update == 1 {
                self.messageLabel.text = self.am.u
            } else {
                self.messageLabel.text = self.am.r
            }
        } else {
            self.messageLabel.text = self.am.e
        }
    }

    func deviceObjectSynced(success: Bool) {
        let t : String
        if success == true {
            t = NSLocalizedString("device_synced", comment: "The device settings have been synchronized with the API")
        } else {
            t = NSLocalizedString("device_local", comment: "Using local device settings")
        }
        self.messageLabel.text = "\(self.messageLabel.text!)\n\(t)"
    }

    func userObjectSynced(success: Bool) {
        self.continueButton.userInteractionEnabled = true
        let t : String
        if success == true {
            t = NSLocalizedString("user_synced", comment: "The user settings have been synchronized with the API")
        } else {
            t = NSLocalizedString("user_local", comment: "Using local user settings")
        }
        self.messageLabel.text = "\(self.messageLabel.text!)\n\(t)"

    }
 
    func authenticationResponse(success: Bool) {
        let lm = LoginManager.sharedInstance
        self.messageLabel.text = "\(lm.object.message)"
        if success == true {
            // update user to the correct information
            let um = UserManager.sharedInstance
            um.object.username = lm.object.username
            um.object.password = lm.object.password
            um.saveToLocal()
            
            um.pushToRemote()
            // segue to application
            
            if self.lm.object.authenticated == true {
                self.performSegueWithIdentifier("showList", sender: self)
            } else {
                self.performSegueWithIdentifier("showLogin", sender: self)
            }
            
        }
    }
    
    
}

