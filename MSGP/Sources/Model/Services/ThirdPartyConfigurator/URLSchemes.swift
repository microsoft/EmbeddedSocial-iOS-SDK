//
//  URLSchemes.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/11/17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import TwitterKit

struct FacebookURLScheme: URLScheme {
    
    func application(_ application: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool {
        guard let source = options["UIApplicationOpenURLOptionsSourceApplicationKey"] as? String,
            let annotation = options["UIApplicationOpenURLOptionsAnnotationKey"],
            let scheme = url.scheme
            else {
                return false
        }
        
        if scheme.hasPrefix("fb") && url.host == "authorize" {
            return FBSDKApplicationDelegate.sharedInstance()
                .application(application, open: url, sourceApplication: source, annotation: annotation)
        }
        
        return false
    }
}

struct TwitterURLScheme: URLScheme {
    
    func application(_ application: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool {
        if let scheme = url.scheme, scheme.hasPrefix("twitterkit") {
            return Twitter.sharedInstance().application(application, open: url, options: options)
        }
        
        return false
    }
}
