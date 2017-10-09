//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

extension AuthProvider {
    var sessionServiceIdentityProvider: SessionsAPI.IdentityProvider_requestTokensGetRequestToken {
        switch self {
        case .facebook: return .facebook
        case .microsoft: return .microsoft
        case .google: return .google
        case .twitter: return .twitter
        }
    }
    
    var usersAPIIdentityProvider: UsersAPI.IdentityProvider_myLinkedAccountsDeleteLinkedAccount {
        switch self {
        case .facebook: return .facebook
        case .microsoft: return .microsoft
        case .google: return .google
        case .twitter: return .twitter
        }
    }
}
