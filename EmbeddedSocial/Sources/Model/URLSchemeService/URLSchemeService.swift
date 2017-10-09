//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol URLScheme {
    func application(_ application: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool
}

struct URLSchemeService: URLSchemeServiceType {
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
