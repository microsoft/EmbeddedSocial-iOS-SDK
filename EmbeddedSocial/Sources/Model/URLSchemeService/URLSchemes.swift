//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import FBSDKCoreKit
import TwitterKit
import GoogleSignIn

struct FacebookURLScheme: URLScheme {
    
    func application(_ application: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool {
        guard let scheme = url.scheme, scheme.hasPrefix("fb") else {
            return false
        }
        
        let (source, annotation) = sourceAndAnnotation(from: options)
        
        return FBSDKApplicationDelegate.sharedInstance()
            .application(application, open: url, sourceApplication: source, annotation: annotation)
    }
}

struct TwitterURLScheme: URLScheme {
    
    func application(_ application: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool {
        guard let scheme = url.scheme, scheme.hasPrefix("twitterkit") else {
            return false
        }
        return Twitter.sharedInstance().application(application, open: url, options: options)
    }
}

struct GoogleURLScheme: URLScheme {
    
    func application(_ application: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool {
        let (source, annotation) = sourceAndAnnotation(from: options)
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: source, annotation: annotation)
    }
}

struct OAuthURLScheme: URLScheme {
    
    func application(_ application: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool {
        if url.host == "oauth-callback" {
            OAuthSwift.handle(url: url)
            return true
        }
        return false
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
