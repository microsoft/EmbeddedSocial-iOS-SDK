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
    var msgp: MSGP!
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
        
        msgp = MSGP(application: application, window: window!, launchOptions: launchOptions ?? [:])
        msgp.start()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        return msgp.application(app, open: url, options: options)
    }
    
    /// iOS 8 support
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        var options: [String: Any] = ["UIApplicationOpenURLOptionsAnnotationKey": annotation]
        
        if let sourceApplication = sourceApplication {
            options["UIApplicationOpenURLOptionsSourceApplicationKey"] = sourceApplication
        }
        
        return msgp.application(application, open: url as URL, options: options)
    }
}
