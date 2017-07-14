//
//  ThirdPartyConfigurator.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/10/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import TwitterKit
import GoogleSignIn

class ThirdPartyConfigurator {

    static func setup(application: UIApplication, launchOptions: [AnyHashable: Any]) {
        setupTwitter()
        setupFacebook(application: application, launchOptions: launchOptions)
        setupGoogle()
    }
    
    private static func setupTwitter() {
        Twitter.sharedInstance().start(withConsumerKey:"2dw07dxA952U3QmEcT3TruHbd",
                                       consumerSecret:"c1eoCNGZP0hJ3UHiB50qIh9Y0TMSDq8LOYZ3gJO8blsql9sRB5")
    }
    
    private static func setupFacebook(application: UIApplication, launchOptions: [AnyHashable: Any]) {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private static func setupGoogle() {
        GIDSignIn.sharedInstance().clientID = "725637580373-0ssr452m7o5bg1aeomsts88ci6tvmp83.apps.googleusercontent.com"
    }
}
