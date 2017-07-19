//
//  AuthServiceImplementation.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/10/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

final class AuthService: AuthServiceType {
    private let apiProvider: AuthAPIProvider
    private var apis: [AuthProvider: AuthAPI] = [:]
    
    init(apiProvider: AuthAPIProvider) {
        self.apiProvider = apiProvider
    }
    
    func login(with provider: AuthProvider,
               from viewController: UIViewController?,
               handler: @escaping (Result<SocialUser>) -> Void) {
        api(for: provider).login(from: viewController) { result in
            handler(result)
        }
    }
    
    private func api(for provider: AuthProvider) -> AuthAPI {
        if let api = apis[provider] {
            return api
        } else {
            let api = apiProvider.api(for: provider)
            apis[provider] = api
            return api
        }
    }
}
