//
//  ThirdPartyConfigurator.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/10/17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import TwitterKit

protocol URLScheme {
    func application(_ application: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool
}

class ThirdPartyConfigurator {
    
    private let urlSchemes: [URLScheme] = [FacebookURLScheme(), TwitterURLScheme()]
    private let app: UIApplication
    private let launchOptions: [AnyHashable: Any]

    init(application: UIApplication, launchOptions: [AnyHashable: Any]) {
        self.app = application
        self.launchOptions = launchOptions
    }
    
    func setup() {
        FBSDKApplicationDelegate.sharedInstance().application(app, didFinishLaunchingWithOptions: launchOptions)
        
        Twitter.sharedInstance().start(withConsumerKey:"2dw07dxA952U3QmEcT3TruHbd",
                                       consumerSecret:"c1eoCNGZP0hJ3UHiB50qIh9Y0TMSDq8LOYZ3gJO8blsql9sRB5")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [AnyHashable: Any] = [:]) -> Bool {
        return urlSchemes.reduce(false) { (result, scheme) in
            return result || scheme.application(app, open: url, options: options)
        }
    }
}
