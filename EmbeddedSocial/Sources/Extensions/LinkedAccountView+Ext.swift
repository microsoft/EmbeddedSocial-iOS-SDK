//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

extension LinkedAccountView {
    
    convenience init(json: [String: Any]) {
        self.init()
        accountId = json["accountId"] as? String
        identityProvider = IdentityProvider(rawValue: json["identityProvider"] as? String ?? "")
    }
}

extension LinkedAccountView.IdentityProvider {
    
    var authProvider: AuthProvider? {
        switch self {
        case .facebook:
            return .facebook
        case .google:
            return .google
        case .microsoft:
            return .microsoft
        case .twitter:
            return .twitter
        default:
            return nil
        }
    }
}
