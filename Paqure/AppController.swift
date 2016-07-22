//
//  AppController.swift
//  Paqure
//
//  Created by Linguri Technology on 7/19/16.
//  Copyright © 2016 Digices. All rights reserved.
//

import UIKit

class AppController: UIViewController, AppManagerDelegate, DeviceManagerDelegate, UserManagerDelegate {

    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var copyrightLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up title and state for button
        self.continueButton.setTitle(NSLocalizedString("continue", comment: "Continue to next screen."), forState: .Normal)
        self.continueButton.userInteractionEnabled = false
        
        // set this to a space so we can safely force unwrap when appending
        self.messageLabel.text = " "
        
        let am = AppManager.sharedInstance
        am.setController(self)
        self.messageLabel.text = am.m
        
        let dm = DeviceManager.sharedInstance
        dm.setController(self)
        
        let um = UserManager.sharedInstance
        um.setController(self)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTouchContinue(sender: AnyObject) {
        // segue to user to test
        self.performSegueWithIdentifier("showUser", sender: self)
    }

    func appObjectSynced(success : Bool) {
        let am = AppManager.sharedInstance
        self.nameLabel.text = am.object.name as String
        self.versionLabel.text = "\(am.v) \(am.object.major).\(am.object.minor).\(am.object.fix)"
        self.copyrightLabel.text = "\(am.c) \(am.object.copyright) \(am.object.company)"
        if success == true {
            if am.object.update == 1 {
                self.messageLabel.text = am.u
            } else {
                self.messageLabel.text = am.r
            }
        } else {
            self.messageLabel.text = am.e
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
    
}

