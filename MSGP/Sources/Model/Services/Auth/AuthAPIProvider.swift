//
//  AuthAPIProvider.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/11/17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import Foundation

struct AuthAPIProvider: AuthAPIProviderType {
    
    func api(for provider: AuthProvider) -> AuthAPI {
        switch provider {
        case .facebook:
            return FacebookAPI()
        case .twitter:
            return TwitterAPI()
        case .google:
            return GoogleAPI()
        default:
            return FacebookAPI()
        }
    }
}
