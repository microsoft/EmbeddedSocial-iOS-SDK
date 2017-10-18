//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import EmbeddedSocial
import HockeySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let menu = MyAppMenu()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // HockeyApp configuration to enable analytics
        BITHockeyManager.shared().configure(withIdentifier: "46cc5ba83a8043b9a4b67cc0f9c6c9a2")
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
        
        if (ProcessInfo.processInfo.environment["EmbeddedSocial_MOCK_SERVER"] != nil) {
            UIView.setAnimationsEnabled(false)
        }
        
        let args = LaunchArguments(app: application,
                                   window: window!,
                                   launchOptions: launchOptions ?? [:],
                                   menuHandler: menu,
                                   menuConfiguration: .tab)
        SocialPlus.shared.start(launchArguments: args)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        return SocialPlus.shared.application(app, open: url, options: options)
    }
    
    /// iOS 8 support
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        var options: [String: Any] = ["UIApplicationOpenURLOptionsAnnotationKey": annotation]
        
        if let sourceApplication = sourceApplication {
            options["UIApplicationOpenURLOptionsSourceApplicationKey"] = sourceApplication
        }
        
        return SocialPlus.shared.application(application, open: url as URL, options: options)
    }
}
