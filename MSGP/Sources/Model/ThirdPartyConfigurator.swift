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
        
        Twitter.sharedInstance().start(withConsumerKey:"3wejbkMdljNjIXEZE7xyI3flG",
                                       consumerSecret:"fhGhZ2bzx9A6kU2pVFdcq7RK7bEJk5niCqS6fKJpA0sQqEwS5t")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [AnyHashable: Any] = [:]) -> Bool {
        return urlSchemes.reduce(false) { (result, scheme) in
            return result || scheme.application(app, open: url, options: options)
        }
    }
}
