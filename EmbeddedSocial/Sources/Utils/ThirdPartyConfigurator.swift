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
        setupTwitter()
        setupFacebook(application: application, launchOptions: launchOptions)
        setupGoogle()
    }
    
    private func setupTwitter() {
        Twitter.sharedInstance().start(withConsumerKey: Keys.twitterConsumerKey,
                                       consumerSecret: Keys.twitterConsumerSecret)
    }
    
    private func setupFacebook(application: UIApplication, launchOptions: [AnyHashable: Any]) {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func setupGoogle() {
        GIDSignIn.sharedInstance().clientID = "348861152334-5hdrnh6qal3trt8m2ukv26due7fn20k0.apps.googleusercontent.com"
    }
    
    private func setupHockeyApp() {
        BITHockeyManager.shared().configure(withIdentifier: "46cc5ba83a8043b9a4b67cc0f9c6c9a2")
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation()
        
        if TARGET_OS_SIMULATOR != 0 {
            BITHockeyManager.shared().isUpdateManagerDisabled = true
        }
    }
}

extension ThirdPartyConfigurator {
    struct Keys {
        static let twitterConsumerKey = "2dw07dxA952U3QmEcT3TruHbd"
        static let twitterConsumerSecret = "c1eoCNGZP0hJ3UHiB50qIh9Y0TMSDq8LOYZ3gJO8blsql9sRB5"
        
        static let microsoftClientID = "5e4ecf55-0958-4324-b32a-332e42064697"
    }
}
