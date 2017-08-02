//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol UserProfileInteractorInput {    
    func getUser(userID: String, completion: @escaping (Result<User>) -> Void)
    
    func getMe(credentials: CredentialsList, completion: @escaping (Result<User>) -> Void)
        
    func getRecentPosts(userID: String, completion: @escaping (Result<[Any]>) -> Void)
    
    func getPopularPosts(userID: String, completion: @escaping (Result<[Any]>) -> Void)
    
    func getMyRecentPosts(completion: @escaping (Result<[Any]>) -> Void)

    func getMyPopularPosts(completion: @escaping (Result<[Any]>) -> Void)

    func follow(userID: String, completion: @escaping (Result<Void>) -> Void)
    
    func unfollow(userID: String, completion: @escaping (Result<Void>) -> Void)
    
    func cancelPending(userID: String, completion: @escaping (Result<Void>) -> Void)
    
    func unblock(userID: String, completion: @escaping (Result<Void>) -> Void)
    
    func block(userID: String, completion: @escaping (Result<Void>) -> Void)
}
