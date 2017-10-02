//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class LinkedAccountsInteractor: LinkedAccountsInteractorInput {
    
    private let usersService: UserServiceType
    private let authService: AuthServiceType
    private let sessionToken: String

    init(usersService: UserServiceType, authService: AuthServiceType, sessionToken: String) {
        self.usersService = usersService
        self.authService = authService
        self.sessionToken = sessionToken
    }
    
    func getLinkedAccounts(completion: @escaping (Result<[LinkedAccountView]>) -> Void) {
        usersService.getLinkedAccounts(completion: completion)
    }
    
    func login(with provider: AuthProvider,
               from viewController: UIViewController?,
               completion: @escaping (Result<Authorization>) -> Void) {
        
        authService.login(with: provider, from: viewController) { result in
            completion(result.map { $0.credentials.authorization })
        }
    }
    
    func linkAccount(authorization: Authorization, completion: @escaping (Result<Void>) -> Void) {
        usersService.linkAccount(authorization: authorization, sessionToken: sessionToken, completion: completion)
    }
    
    func deleteLinkedAccount(provider: AuthProvider, completion: @escaping (Result<Void>) -> Void) {
        usersService.deleteLinkedAccount(for: provider, completion: completion)
    }
}
