//
//  UserService.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/18/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

protocol UserServiceType {
    func getMyProfile(socialUser: SocialUser, completion: @escaping (Result<User>) -> Void)
    
    func createAccount(for user: SocialUser, completion: @escaping (Result<(user: User, sessionToken: String)>) -> Void)
}

struct UserService: UserServiceType {
    
    func getMyProfile(socialUser: SocialUser, completion: @escaping (Result<User>) -> Void) {
        APISettings.shared.customHeaders = socialUser.credentials.authHeader
        
        UsersAPI.usersGetMyProfile { profile, error in
            guard let profile = profile,
                let userHandle = profile.userHandle else {
                    completion(.failure(error ?? APIError.missingUserData))
                    return
            }
            
            let user = User(socialUser: socialUser, userHandle: userHandle)
            completion(.success(user))
        }
    }
    
    func createAccount(for user: SocialUser, completion: @escaping (Result<(user: User, sessionToken: String)>) -> Void) {
        APISettings.shared.customHeaders = user.credentials.authHeader

        let params = PostUserRequest()
        params.instanceId = user.uid
        params.firstName = user.firstName
        params.lastName = user.lastName
        params.bio = user.bio
        params.photoHandle = user.photo?.uid
        
        UsersAPI.usersPostUser(request: params) { response, error in
            if let response = response,
                let userHandle = response.userHandle,
                let sessionToken = response.sessionToken {
                let user = User(socialUser: user, userHandle: userHandle)
                completion(.success((user, sessionToken)))
            } else {
                completion(.failure(error ?? APIError.custom("Failed to create new profile.")))
            }
        }
    }
}
