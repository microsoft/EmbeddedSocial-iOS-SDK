//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol UserServiceType {
    func getMyProfile(credentials: CredentialsList, completion: @escaping (Result<User>) -> Void)
    
    func getUserProfile(userID: String, completion: @escaping (Result<User>) -> Void)
    
    func createAccount(for user: SocialUser, completion: @escaping (Result<(user: User, sessionToken: String)>) -> Void)
}

class UserService: BaseService, UserServiceType {
    
    func getMyProfile(credentials: CredentialsList, completion: @escaping (Result<User>) -> Void) {
        UsersAPI.usersGetMyProfile(authorization: credentials.authorization) { profile, error in
            if let profile = profile {
                let user = User(profileView: profile, credentials: credentials)
                completion(.success(user))
            } else {
                self.errorHandler.handle(error: error, completion: completion)
            }
        }
    }
    
    func createAccount(for user: SocialUser, completion: @escaping (Result<(user: User, sessionToken: String)>) -> Void) {
        let params = PostUserRequest()
        params.instanceId = user.uid
        params.firstName = user.firstName
        params.lastName = user.lastName
        params.bio = user.bio
        params.photoHandle = user.photo?.uid
        
        UsersAPI.usersPostUser(request: params, authorization: authorization) { response, error in
            if let response = response, let userHandle = response.userHandle, let sessionToken = response.sessionToken {
                let user = User(socialUser: user, userHandle: userHandle)
                completion(.success((user, sessionToken)))
            } else {
                self.errorHandler.handle(error: error, completion: completion)
            }
        }
    }
    
    func getUserProfile(userID: String, completion: @escaping (Result<User>) -> Void) {
        UsersAPI.usersGetUser(userHandle: userID, authorization: authorization) { profile, error in
            if let profile = profile {
                let user = User(profileView: profile)
                completion(.success(user))
            } else {
                self.errorHandler.handle(error: error, completion: completion)
            }
        }
    }
}
