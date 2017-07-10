//
//  AuthServiceImplementation.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/10/17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import Foundation

struct AuthAPIProvider: AuthAPIProviderType {
    
    func api(for provider: AuthProvider) -> AuthAPI {
        return FacebookAPI()
    }
}

final class AuthService: AuthServiceType {
    private let apiProvider: AuthAPIProvider
    
    init(apiProvider: AuthAPIProvider) {
        self.apiProvider = apiProvider
    }
    
    func login(provider: AuthProvider, handler: @escaping (Result<User>) -> Void) {
        let api = apiProvider.api(for: provider)
        api.login { result in
            _ = api // to extend lifetime
            handler(.success(User(username: "\(provider)-user")))
        }
    }
    
    func login(email: String, password: String, handler: @escaping (Result<User>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            handler(.success(User(username: email)))
        }
    }
    
    func createAccount(email: String, password: String, handler: @escaping (Result<User>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            handler(.success(User(username: email)))
        }
    }
}
