//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
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
            guard let user = result.value, let credentials = user.credentials else {
                handler(.failure(result.error ?? APIError.failedRequest))
                return
            }
            
            self?.sessionService.makeNewSession(with: credentials, userUID: user.uid) { result in
                if let sessionToken = result.value {
                    handler(.success((user, sessionToken)))
                } else {
                    handler(.failure(result.error ?? APIError.failedRequest))
                }
            }
        }
    }
}
