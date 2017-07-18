//
//  UserService.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/18/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

protocol UserServiceType {
    func getMyProfile(credentials: CredentialsList, completion: @escaping (Result<User>) -> Void)
}

struct UserService: UserServiceType {
    
    func getMyProfile(credentials: CredentialsList, completion: @escaping (Result<User>) -> Void) {
        EmbeddedSocialClientAPIAdaptor.shared.customHeaders = credentials.authHeader
        
        UsersAPI.usersGetMyProfile { profile, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let profile = profile,
                let uid = profile.userHandle else {
                    fatalError("Profile data is missing however no error was reported.")
            }
            
            let user = User(uid: uid,
                            firstName: profile.firstName,
                            lastName: profile.lastName,
                            email: nil,
                            bio: profile.bio,
                            photo: Photo(uid: profile.photoHandle ?? UUID().uuidString, url: profile.photoUrl),
                            credentials: credentials)
            
            completion(.success(user))
        }
    }
}
