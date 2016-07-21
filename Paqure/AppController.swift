//
//  AppController.swift
//  Paqure
//
//  Created by Linguri Technology on 7/19/16.
//  Copyright © 2016 Digices. All rights reserved.
//

import UIKit

class AppController: UIViewController {

    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var copyrightLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTouchContinue(sender: AnyObject) {
        // segue to application or login
    }

}
