//
//  AuthAPIProvider.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/11/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

struct AuthAPIProvider: AuthAPIProviderType {
    
    func api(for provider: AuthProvider) -> AuthAPI {
        switch provider {
        case .facebook:
            return FacebookAPI()
        case .twitter:
            return TwitterWebBasedAPI()
        case .google:
            return GoogleAPI()
        case .microsoft:
            return MicrosoftLiveAPI()
        }
    }
}
