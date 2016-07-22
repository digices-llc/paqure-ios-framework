//
//  UserController.swift
//  Paqure
//
//  Created by Linguri Technology on 7/21/16.
//  Copyright © 2016 Digices. All rights reserved.
//

import UIKit

class UserController: UIViewController, UserManagerDelegate {

    let um : UserManager = UserManager.sharedInstance
    
    @IBOutlet weak var idField: UITextField!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var firstField: UITextField!
    
    @IBOutlet weak var lastField: UITextField!
    
    @IBOutlet weak var ageField: UITextField!
    
    @IBOutlet weak var statusField: UITextField!
    
    @IBOutlet weak var updateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.um.setController(self)
        self.updateUI()
    }
    
    func updateUI() {
        self.idField.text = "\(self.um.object.id)"
        self.usernameField.text = self.um.object.username as String
        self.passwordField.text = self.um.object.password as String
        self.emailField.text = self.um.object.email as String
        self.firstField.text = self.um.object.first as String
        self.lastField.text = self.um.object.last as String
        self.ageField.text = "\(self.um.object.age)"
        
        switch self.um.object.status {
        case 1:
            self.statusField.text = "authorized"
        case 2:
            self.statusField.text = "readonly"
        case 3:
            self.statusField.text = "expired"
        case 4:
            self.statusField.text = "suspended"
        default:
            self.statusField.text = "none"
        }
        self.updateButton.setTitle("update", forState: .Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTouchUpdate(sender: AnyObject) {
        if self.passwordField.text?.characters.count > 0 {
            self.um.object.password = self.usernameField.text! as NSString
            self.um.saveToLocal()
            self.um.pushToRemote()
        }
    }
    
    func userObjectSynced(success: Bool) {
        // update UI
    }
}
