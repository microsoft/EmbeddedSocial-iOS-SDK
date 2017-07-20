//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import MSGP

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var myAppMenu: SideMenuItemsProvider?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        
        
        // Menu delegate
        myAppMenu = MyAppMenu()
        
        SocialPlus.shared.start(with: application,
                                window: window!,
                                launchOptions: launchOptions ?? [:],
                                menuHandler: myAppMenu,
                                menuConfiguration: .dual)
        
        window?.makeKeyAndVisible()
        
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
