//
//  DeviceController.swift
//  Paqure
//
//  Created by Linguri Technology on 7/21/16.
//  Copyright © 2016 Digices. All rights reserved.
//

import UIKit

class DeviceController: UIViewController, DeviceManagerDelegate {
    
    @IBOutlet weak var labelLabel: UITextField!
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var identifierLabel: UILabel!
    
    @IBOutlet weak var localeLabel: UILabel!
    
    @IBOutlet weak var tokenLabel: UILabel!
    
    @IBOutlet weak var createdLabel: UILabel!
    
    @IBOutlet weak var modifiedLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var updateButton: UIButton!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateButton.setTitle(NSLocalizedString("update", comment: "Update record in database"), forState: .Normal)

        let dm = DeviceManager.sharedInstance
        dm.setController(self)
        self.updateUI()
    }

    func updateUI() {
        let dm = DeviceManager.sharedInstance

        labelLabel.text = dm.object.label.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
        if labelLabel.text?.characters.count == 0 {
            labelLabel.placeholder = NSLocalizedString("device_name", comment: "User defined label to identify device")
        }

        idLabel.text = "\(dm.object.id)"
        identifierLabel.text = dm.object.identifier as String
        localeLabel.text = dm.object.locale as String
        tokenLabel.text = dm.object.token as String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.locale = NSLocale(localeIdentifier: dm.object.locale as String)
        
        let crxdate = NSDate(timeIntervalSince1970: Double(dm.object.created))
        createdLabel.text = dateFormatter.stringFromDate(crxdate)
        
        let mfxdate = NSDate(timeIntervalSince1970: Double(dm.object.modified))
        modifiedLabel.text = dateFormatter.stringFromDate(mfxdate)
        
        switch dm.object.status {
        case 1:
            self.statusLabel.text = NSLocalizedString("authorized", comment: "Device has been approved to receive premium data from API")
        case 2:
            self.statusLabel.text = NSLocalizedString("readonly", comment: "Device can only read from API")
        case 3:
            self.statusLabel.text = NSLocalizedString("expired", comment: "Previous authorization has expired.")
        case 4:
            self.statusLabel.text = NSLocalizedString("suspended", comment: "Device is not allowed to access API.")
        default:
            self.statusLabel.text = NSLocalizedString("none", comment: "No approval status")
        }
        
    }
    
    @IBAction func didTouchUpdateButton(sender: AnyObject) {
        let dm = DeviceManager.sharedInstance
        dm.setController(self)
        if labelLabel.text?.characters.count > 0 {
            dm.object.label = self.labelLabel.text! as NSString
            dm.saveToLocal()
            dm.pushToRemote()
        }
    }
    
    func deviceObjectSynced() {
        self.updateUI()
        self.messageLabel.text = NSLocalizedString("saved", comment: "Record has been saved to database")
    }
    
}