//
//  AppDelegate.swift
//  MSGP-Example
//
//  Created by Vadim Bulavin on 7/10/17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import UIKit
import MSGP

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        API.injectMenuStackIntoApp(window: self.window!)
        API.setMenuItems(["lol", "lel"], format: .single, delegate: nil)
        
        return true
    }
}
