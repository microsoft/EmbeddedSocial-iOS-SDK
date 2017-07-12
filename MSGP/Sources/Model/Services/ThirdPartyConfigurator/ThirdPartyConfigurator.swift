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
import Google
import FirebaseCore

protocol URLScheme {
    func application(_ application: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool
}

class ThirdPartyConfigurator {
    
    private let urlSchemes: [URLScheme] = [FacebookURLScheme(), TwitterURLScheme(), GoogleURLScheme()]
    private let app: UIApplication
    private let launchOptions: [AnyHashable: Any]

    init(application: UIApplication, launchOptions: [AnyHashable: Any]) {
        self.app = application
        self.launchOptions = launchOptions
    }
    
    func setup() {
        setupTwitter()
        setupFacebook()
        setupGoogle()
    }
    
    private func setupTwitter() {
        Twitter.sharedInstance().start(withConsumerKey:"2dw07dxA952U3QmEcT3TruHbd",
                                       consumerSecret:"c1eoCNGZP0hJ3UHiB50qIh9Y0TMSDq8LOYZ3gJO8blsql9sRB5")
    }
    
    private func setupFacebook() {
        FBSDKApplicationDelegate.sharedInstance().application(app, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func setupGoogle() {
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        guard configureError == nil else {
            fatalError("Error configuring Google services: \(configureError!)")
        }
        GIDSignIn.sharedInstance().clientID = "725637580373-0ssr452m7o5bg1aeomsts88ci6tvmp83.apps.googleusercontent.com"
        FIRAnalyticsConfiguration.sharedInstance().setAnalyticsCollectionEnabled(false)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [AnyHashable: Any] = [:]) -> Bool {
        return urlSchemes.reduce(false) { (result, scheme) in
            return result || scheme.application(app, open: url, options: options)
        }
    }
}
