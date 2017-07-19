//
//  AuthServiceImplementation.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/10/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

final class AuthService: AuthServiceType {
    private let apiProvider: AuthAPIProvider
    
    init(apiProvider: AuthAPIProvider) {
        self.apiProvider = apiProvider
    }
    
    func login(with provider: AuthProvider,
               from viewController: UIViewController?,
               handler: @escaping (Result<SocialUser>) -> Void) {
        
        let socialAPI = apiProvider.api(for: provider)
        socialAPI.login(from: viewController) { result in
            _ = socialAPI // to extend lifetime
            handler(result)
        }
    }
    
    func createAccount(for user: SocialUser, completion: @escaping (Result<(user: User, sessionToken: String)>) -> Void) {
        let params = PostUserRequest()
        params.instanceId = user.uid
        params.firstName = user.firstName
        params.lastName = user.lastName
        params.bio = user.bio
        params.photoHandle = user.photo?.uid
        
        APISettings.shared.customHeaders = user.credentials.authHeader
        
        UsersAPI.usersPostUser(request: params) { response, error in
            if let error = error {
                completion(.failure(error))
            } else if let response = response,
                let userHandle = response.userHandle,
                let sessionToken = response.sessionToken {
                let user = User(socialUser: user, userHandle: userHandle)
                completion(.success((user, sessionToken)))
            } else {
                completion(.failure(AuthError.createError))
            }
        }
    }
}

extension AuthService {
    enum AuthError: LocalizedError {
        case createError
        
        public var errorDescription: String? {
            switch self {
            case .createError: return "Failed to create an account."
            }
        }
    }
}
