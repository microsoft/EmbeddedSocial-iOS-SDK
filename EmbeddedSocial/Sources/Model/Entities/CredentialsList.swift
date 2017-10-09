//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

typealias Authorization = String

struct CredentialsList {
    let provider: AuthProvider
    let accessToken: String
    let requestToken: String?
    let appKey: String
    let socialUID: String
    
    init(provider: AuthProvider, accessToken: String, requestToken: String? = nil,
         socialUID: String, appKey: String = Constants.appKey) {
        self.provider = provider
        self.accessToken = accessToken
        self.requestToken = requestToken
        self.socialUID = socialUID
        self.appKey = appKey
    }
    
    var authorization: Authorization {
        switch provider {
        case .facebook, .google, .microsoft:
            return String(format: apiTemplate, provider.name, appKey, accessToken)
        case .twitter where requestToken != nil:
            return String(format: apiTemplate, provider.name, appKey, requestToken!, accessToken)
        default:
            fatalError("Twitter requestToken is missing or auth provider is not supported")
        }
    }
    
    private var apiTemplate: String {
        switch provider {
        case .facebook, .google, .microsoft:
            return "%@ AK=%@|TK=%@"
        case .twitter:
            return "%@ AK=%@|RT=%@|TK=%@"
        }
    }
}
