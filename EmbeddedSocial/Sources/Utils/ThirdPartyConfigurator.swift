//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import FBSDKCoreKit
import TwitterKit
import GoogleSignIn
import HockeySDK

protocol ThirdPartyConfiguratorType {
    func setup(application: UIApplication, launchOptions: [AnyHashable: Any])
}

struct ThirdPartyConfigurator: ThirdPartyConfiguratorType {

    func setup(application: UIApplication, launchOptions: [AnyHashable: Any]) {
        setupHockeyApp()
        setupTwitter()
        setupFacebook(application: application, launchOptions: launchOptions)
        setupGoogle()
    }
    
    private func setupTwitter() {
        Twitter.sharedInstance().start(withConsumerKey: Keys.twitterConsumerKey,
                                       consumerSecret: Keys.twitterConsumerSecret)
    }
    
    private func setupFacebook(application: UIApplication, launchOptions: [AnyHashable: Any]) {
        FBSDKSettings.setAppID(Keys.facebookAppID)
        FBSDKSettings.setDisplayName(Keys.facebookDisplayName)
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func setupGoogle() {
        GIDSignIn.sharedInstance().clientID = Keys.googleClientID
    }
    
    private func setupHockeyApp() {
        BITHockeyManager.shared().configure(withIdentifier: Keys.hockeyClientID)
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation()
        
        if TARGET_OS_SIMULATOR != 0 {
            BITHockeyManager.shared().isUpdateManagerDisabled = true
        }
    }
}

extension ThirdPartyConfigurator {
    struct Keys {
        static let facebookAppID = "143359739619521"
        static let facebookDisplayName = "Embedded Social"
        static let hockeyClientID = "46cc5ba83a8043b9a4b67cc0f9c6c9a2"
        static let googleClientID = "348861152334-5hdrnh6qal3trt8m2ukv26due7fn20k0.apps.googleusercontent.com"
        static let microsoftClientID = "5e4ecf55-0958-4324-b32a-332e42064697"
        static let twitterConsumerKey = "2dw07dxA952U3QmEcT3TruHbd"
        static let twitterConsumerSecret = "c1eoCNGZP0hJ3UHiB50qIh9Y0TMSDq8LOYZ3gJO8blsql9sRB5"
    }
}
