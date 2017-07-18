//
//  LoginLoginInteractor.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

class LoginInteractor: LoginInteractorInput {
    
    private let authService: AuthServiceType
    private let userService: UserServiceType

    init(authService: AuthServiceType, userService: UserServiceType) {
        self.authService = authService
        self.userService = userService
    }
    
    func login(provider: AuthProvider, from viewController: UIViewController?, handler: @escaping (Result<SocialUser>) -> Void) {
        authService.login(with: provider, from: viewController, handler: handler)
    }
    
    func getMyProfile(credentials: CredentialsList, handler: @escaping (Result<User>) -> Void) {
        userService.getMyProfile(credentials: credentials, completion: handler)
    }
}
