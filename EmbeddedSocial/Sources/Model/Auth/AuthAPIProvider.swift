//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct AuthAPIProvider: AuthAPIProviderType {
    
    func api(for provider: AuthProvider) -> AuthAPI {
        switch provider {
        case .facebook:
            return FacebookAPI()
        case .twitter:
            return TwitterServerBasedAPI()
        case .google:
            return GoogleAPI()
        case .microsoft:
            return MicrosoftLiveAPI()
        }
    }
}
