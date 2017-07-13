//
//  CreateAccountCreateAccountInteractor.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

final class CreateAccountInteractor: CreateAccountInteractorInput {
    private let authService: AuthServiceType
    
    init(authService: AuthServiceType) {
        self.authService = authService
    }
    
    func createAccount(for user: User, completion: @escaping (Result<User>) -> Void) {
        
    }
}
