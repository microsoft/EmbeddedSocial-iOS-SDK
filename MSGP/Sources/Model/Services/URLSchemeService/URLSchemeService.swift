//
//  URLSchemeService.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/12/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

protocol URLScheme {
    func application(_ application: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool
}

struct URLSchemeService {
    private let schemes: [URLScheme]
    
    init(schemes: [URLScheme] = URLSchemeService.defaultSchemes) {
        self.schemes = schemes
    }

    func application(_ app: UIApplication, open url: URL, options: [AnyHashable: Any] = [:]) -> Bool {
        return schemes.reduce(false) { (result, scheme) in
            return result || scheme.application(app, open: url, options: options)
        }
    }
}

extension URLSchemeService {
    static let defaultSchemes: [URLScheme] = [
        FacebookURLScheme(),
        TwitterURLScheme(),
        GoogleURLScheme(),
        OAuthURLScheme()
    ]
}
