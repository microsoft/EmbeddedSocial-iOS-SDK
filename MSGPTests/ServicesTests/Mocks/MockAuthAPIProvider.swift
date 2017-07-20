//
//  MockAuthAPIProvider.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/20/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation
@testable import MSGP

struct MockAuthAPIProvider: AuthAPIProviderType {
    private let api: AuthAPI
    
    init(apiToProvide: AuthAPI) {
        api = apiToProvide
    }
    
    func api(for provider: AuthProvider) -> AuthAPI {
        return api
    }
}
