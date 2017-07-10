//
//  ThirdPartyConfigurator.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/10/17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import Foundation
import FBSDKCoreKit

struct ThirdPartyConfigurator {
    
    static func setup(application: UIApplication, launchOptions: [AnyHashable: Any]) {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
