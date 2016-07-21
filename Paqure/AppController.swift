//
//  AppController.swift
//  Paqure
//
//  Created by Linguri Technology on 7/19/16.
//  Copyright © 2016 Digices. All rights reserved.
//

import UIKit

class AppController: UIViewController, AppManagerDelegate {

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
        
        let am = AppManager.sharedInstance
        am.setController(self)
        self.messageLabel.text = am.m

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTouchContinue(sender: AnyObject) {
        // segue to application or login
    }

    func appObjectSynced(success : Bool) {
        self.continueButton.userInteractionEnabled = true
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
    
}
