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
import GoogleSignIn

struct FacebookURLScheme: URLScheme {
    
    func application(_ application: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool {
        if #available(iOS 9.0, *) {
            guard let scheme = url.scheme else {
                return false
            }
            
            let (source, annotation) = sourceAndAnnotation(from: options)
            
            if scheme.hasPrefix("fb") && url.host == "authorize" {
                return FBSDKApplicationDelegate.sharedInstance()
                    .application(application, open: url, sourceApplication: source, annotation: annotation)
            }
            
            return false
        } else {
            fatalError("Not implemented for iOS 8")
        }
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

struct GoogleURLScheme: URLScheme {
    
    func application(_ application: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool {
        let (source, annotation) = sourceAndAnnotation(from: options)
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: source, annotation: annotation)
    }
}

private func sourceAndAnnotation(from options: [AnyHashable: Any]) -> (String?, Any?) {
    var source: String?
    var annotation: Any?
    
    if #available(iOS 9.0, *) {
        source = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        annotation = options[UIApplicationOpenURLOptionsKey.annotation]
    } else {
        source = options["UIApplicationOpenURLOptionsSourceApplicationKey"] as? String
        annotation = options["UIApplicationOpenURLOptionsAnnotationKey"]
    }
    
    return (source, annotation)
}
