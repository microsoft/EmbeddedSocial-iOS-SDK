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
        static let facebookAppID = ""
        static let facebookDisplayName = ""
        static let hockeyClientID = ""
        static let googleClientID = ""
        static let microsoftClientID = ""
        static let twitterConsumerKey = ""
        static let twitterConsumerSecret = ""
    }
}
