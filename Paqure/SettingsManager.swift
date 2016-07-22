//
//  SettingsManager.swift
//  Paqure
//
//  Created by Linguri Technology on 7/21/16.
//  Copyright © 2016 Digices. All rights reserved.
//

import UIKit

public class SettingsManager {
    
    public static var sharedInstance : SettingsManager = SettingsManager()
    
    var objects : [Setting] = []
    
    init() {
        objects.append(Setting(key: "device", title: NSLocalizedString("device_settings", comment: "Mobile device settings")))
        objects.append(Setting(key: "user", title:  NSLocalizedString("user_profile", comment: "User profile and preferences")))
    }
    
}