//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

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
    
    func getMyProfile(socialUser: SocialUser,
                      from viewController: UIViewController?,
                      handler: @escaping (Result<(user: User, sessionToken: String)>) -> Void) {
        
        let creds = socialUser.credentials
        
        userService.getMyProfile(authorization: creds.authorization, credentials: creds) { [weak self] result in
            guard let user = result.value else {
                handler(.failure(result.error ?? APIError.failedRequest))
                return
            }
            
            if creds.provider == .twitter {
                self?.logIntoTwitterAndMakeSession(from: viewController, user: user, handler: handler)
            } else {
                self?.makeNewSession(user: user, handler: handler)
            }
        }
    }
    
    private func makeNewSession(user: User, handler: @escaping (Result<(user: User, sessionToken: String)>) -> Void) {
        guard let credentials = user.credentials else {
            handler(.failure(APIError.failedRequest))
            return
        }
        
        sessionService.makeNewSession(with: credentials, userID: user.uid) { result in
            if let sessionToken = result.value {
                handler(.success((user, sessionToken)))
            } else {
                handler(.failure(result.error ?? APIError.failedRequest))
            }
        }
    }
    
    private func logIntoTwitterAndMakeSession(from viewController: UIViewController?,
                                              user: User,
                                              handler: @escaping (Result<(user: User, sessionToken: String)>) -> Void) {
        
        login(provider: .twitter, from: viewController) { [weak self] result in
            if let socialUser = result.value {
                var user = user
                user.credentials = socialUser.credentials
                self?.makeNewSession(user: user, handler: handler)
            } else {
                handler(.failure(result.error ?? APIError.failedRequest))
            }
        }
    }
}
