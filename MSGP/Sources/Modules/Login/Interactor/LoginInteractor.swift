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
    private let sessionService: SessionServiceType

    init(authService: AuthServiceType, userService: UserServiceType, sessionService: SessionServiceType) {
        self.authService = authService
        self.userService = userService
        self.sessionService = sessionService
    }
    
    func login(provider: AuthProvider, from viewController: UIViewController?, handler: @escaping (Result<SocialUser>) -> Void) {
        authService.login(with: provider, from: viewController, handler: handler)
    }
    
    func getMyProfile(socialUser: SocialUser, handler: @escaping (Result<(user: User, sessionToken: String)>) -> Void) {
        userService.getMyProfile(socialUser: socialUser) { [weak self] result in
            guard let user = result.value else {
                handler(.failure(result.error ?? APIError.failedRequest))
                return
            }
            
            self?.sessionService.makeNewSession(with: user.credentials, userUID: user.uid) { result in
                if let sessionToken = result.value {
                    handler(.success((user, sessionToken)))
                } else {
                    handler(.failure(result.error ?? APIError.failedRequest))
                }
            }
        }
    }
}

extension LoginInteractor {
    struct GetMyProfileResponse {
        let user: User
        let sessionToken: String
    }
}
