//
//  Setting.swift
//  Paqure
//
//  Created by Linguri Technology on 7/21/16.
//  Copyright © 2016 Digices. All rights reserved.
//

import UIKit

class Setting: NSObject {

    var key : String
    var title : String
    
    init(key: String, title: String) {
        self.key = key
        self.title = title
        super.init()
    }
    
}
