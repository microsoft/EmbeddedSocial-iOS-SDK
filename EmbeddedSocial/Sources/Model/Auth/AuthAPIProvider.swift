//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class AuthAPIProvider: AuthAPIProviderType {
    
    func api(for provider: AuthProvider) -> AuthAPI {
        switch provider {
        case .facebook:
            return FacebookAPIImpl(permissions: .basic)
        case .twitter:
            return TwitterServerBasedAPI()
        case .google:
            return GoogleAPI()
        case .microsoft:
            return MicrosoftLiveAPI()
        }
    }
}

final class SuggestedUsersAuthAPIProvider: AuthAPIProvider {
    
    override func api(for provider: AuthProvider) -> AuthAPI {
        if provider == .facebook {
            return FacebookAPIImpl(permissions: .friends)
        }
        return super.api(for: provider)
    }
}
