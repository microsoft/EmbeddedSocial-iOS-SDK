//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

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
    
    var authHeader: [String: String] {
        var value: String = ""
        
        switch provider {
        case .facebook, .google, .microsoft:
            value = String(format: apiTemplate, provider.name, Constants.appKey, accessToken)
        case .twitter where requestToken != nil:
            value = String(format: apiTemplate, provider.name, Constants.appKey, requestToken!, accessToken)
        default:
            fatalError("Twitter requestToken is missing or auth provider is not supported")
        }
        
        return ["Authorization": value]
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

extension CredentialsList: Equatable {
    static func ==(_ lhs: CredentialsList, _ rhs: CredentialsList) -> Bool {
        return lhs.provider == rhs.provider &&
            lhs.accessToken == rhs.accessToken &&
            lhs.requestToken == rhs.requestToken &&
            lhs.appKey == rhs.appKey &&
            lhs.socialUID == rhs.socialUID
    }
}
