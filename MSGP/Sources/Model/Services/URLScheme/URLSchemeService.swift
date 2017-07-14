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
    private let urlSchemes: [URLScheme] = [FacebookURLScheme(), TwitterURLScheme(), GoogleURLScheme(), MicrosoftURLScheme()]

    func application(_ app: UIApplication, open url: URL, options: [AnyHashable: Any] = [:]) -> Bool {
        return urlSchemes.reduce(false) { (result, scheme) in
            return result || scheme.application(app, open: url, options: options)
        }
    }
}
