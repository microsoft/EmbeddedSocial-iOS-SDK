//
//  CreateAccountCreateAccountInteractor.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

final class CreateAccountInteractor: CreateAccountInteractorInput {
    private let userService: UserServiceType

    init(userService: UserServiceType) {
        self.userService = userService
    }
    
    func createAccount(for user: SocialUser, completion: @escaping (Result<(user: User, sessionToken: String)>) -> Void) {
        userService.createAccount(for: user, completion: completion)
    }
}
