//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import EmbeddedSocial
import UserNotifications
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
        
        if TARGET_OS_SIMULATOR != 0 {
            BITHockeyManager.shared().isUpdateManagerDisabled = true
        }
        
        if (ProcessInfo.processInfo.environment["EmbeddedSocial_MOCK_SERVER"] != nil) {
            UIView.setAnimationsEnabled(false)
        }
        
        let args = LaunchArguments(app: application,
                                   window: window!,
                                   launchOptions: launchOptions ?? [:],
                                   menuHandler: menu,
                                   menuConfiguration: .tab)
        SocialPlus.shared.start(launchArguments: args)
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
            }
            application.registerForRemoteNotifications()
        } else {
            // Fallback on earlier versions
        }

        
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
    
    
    /// push notifications
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        SocialPlus.shared.updateDeviceToken(devictToken: deviceTokenString)
        
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
        SocialPlus.shared.didReceiveRemoteNotification(data: data)
        
    }
    
}
