//
//  LoginController.swift
//  Paqure
//
//  Created by Linguri Technology on 7/22/16.
//  Copyright © 2016 Digices. All rights reserved.
//

import UIKit

class LoginController: UIViewController, LoginManagerDelegate {

    var lm = LoginManager.sharedInstance
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var paswordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lm.setController(self)
        self.updateUI()
    }

    func updateUI() {
        self.loginButton.setTitle(lm.object.submit as String, forState: .Normal)
    }
    
    func authenticationResponse(success: Bool) {
        self.messageLabel.text = lm.object.message as String
        if (success == true) {
            //segue to listView
        }
        
    }
    
    @IBAction func didTouchLogin(sender: AnyObject) {
        self.lm.object.username = usernameField.text!
        self.lm.object.password = paswordField.text!
        self.lm.pushToRemote()
    }

}
