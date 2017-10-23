//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class LinkedAccountsInteractor: LinkedAccountsInteractorInput {
    
    private let usersService: UserServiceType
    private let authService: AuthServiceType
    private let sessionToken: String
    
    private var linkedProviders = Set<AuthProvider>()

    init(usersService: UserServiceType, authService: AuthServiceType, sessionToken: String) {
        self.usersService = usersService
        self.authService = authService
        self.sessionToken = sessionToken
    }
    
    func getLinkedAccounts(completion: @escaping (Result<[LinkedAccountView]>) -> Void) {
        usersService.getLinkedAccounts { [weak self] result in
            let providers = result.value?.flatMap { $0.identityProvider?.authProvider } ?? []
            self?.linkedProviders = Set(providers)
            completion(result)
        }
    }
    
    func login(with provider: AuthProvider,
               from viewController: UIViewController?,
               completion: @escaping (Result<Authorization>) -> Void) {
        
        authService.login(with: provider, from: viewController) { result in
            completion(result.map { $0.credentials.authorization })
        }
    }
    
    func linkAccount(provider: AuthProvider, authorization: Authorization, completion: @escaping (Result<Void>) -> Void) {
        usersService.linkAccount(authorization: authorization, sessionToken: sessionToken) { [weak self] result in
            if result.isSuccess {
                self?.linkedProviders.insert(provider)
            }
            completion(result)
        }
    }
    
    func deleteLinkedAccount(provider: AuthProvider, completion: @escaping (Result<Void>) -> Void) {
        guard linkedProviders.count > 1 else {
            completion(.failure(APIError.lastLinkedAccount))
            return
        }
        
        usersService.deleteLinkedAccount(for: provider) { [weak self] result in
            if result.isSuccess {
                self?.linkedProviders.remove(provider)
            }
            completion(result)
        }
    }
}
