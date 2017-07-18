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
    
    func createAccount(for user: SocialUser, completion: @escaping (Result<User>) -> Void) {
        let params = PostUserRequest()
        params.instanceId = user.uid
        params.firstName = user.firstName
        params.lastName = user.lastName
        params.bio = user.bio
        params.photoHandle = user.photo?.uid
        
        EmbeddedSocialClientAPIAdaptor.shared.customHeaders = user.credentials.authHeader
        
        UsersAPI.usersPostUser(request: params) { response, error in
            print(response, error)
        }
    }
}
