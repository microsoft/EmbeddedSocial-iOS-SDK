//
//  CreateAccountCreateAccountInteractor.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

final class CreateAccountInteractor: CreateAccountInteractorInput {
    private let authService: AuthServiceType
    private let user: SocialUser

    init(user: SocialUser, authService: AuthServiceType) {
        self.user = user
        self.authService = authService
    }
    
    func createAccount(for user: SocialUser, completion: @escaping (Result<SocialUser>) -> Void) {
        
    }
}
