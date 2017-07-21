//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
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
        Twitter.sharedInstance().start(withConsumerKey: Keys.twitterConsumerKey,
                                       consumerSecret: Keys.twitterConsumerSecret)
    }
    
    private static func setupFacebook(application: UIApplication, launchOptions: [AnyHashable: Any]) {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private static func setupGoogle() {
        GIDSignIn.sharedInstance().clientID = "725637580373-0ssr452m7o5bg1aeomsts88ci6tvmp83.apps.googleusercontent.com"
    }
}

extension ThirdPartyConfigurator {
    struct Keys {
        static let twitterConsumerKey = "2dw07dxA952U3QmEcT3TruHbd"
        static let twitterConsumerSecret = "c1eoCNGZP0hJ3UHiB50qIh9Y0TMSDq8LOYZ3gJO8blsql9sRB5"
        
        static let microsoftClientID = "5e4ecf55-0958-4324-b32a-332e42064697"
    }
}
