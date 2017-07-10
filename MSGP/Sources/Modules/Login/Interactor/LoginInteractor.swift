//
//  LoginLoginInteractor.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

class LoginInteractor: LoginInteractorInput {
    
    private let authService: AuthServiceType
    
    init(authService: AuthServiceType) {
        self.authService = authService
    }

    func login(provider: AuthProvider, handler: @escaping (Result<User>) -> Void) {
        authService.login(provider: provider) { result in
            handler(result)
        }
    }
}
