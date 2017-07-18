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
}

struct UserService: UserServiceType {
    
    func getMyProfile(socialUser: SocialUser, completion: @escaping (Result<User>) -> Void) {
        EmbeddedSocialClientAPIAdaptor.shared.customHeaders = socialUser.credentials.authHeader
        
        UsersAPI.usersGetMyProfile { profile, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let profile = profile,
                let userHandle = profile.userHandle else {
                    fatalError("Profile data is missing however no error was reported.")
            }
            
            let user = User(socialUser: socialUser, userHandle: userHandle)
            completion(.success(user))
        }
    }
}
