//
//  SocialService.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/27/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

protocol SocialServiceType {
    func follow(userID: String, completion: @escaping (Result<Void>) -> Void)
    
    func unfollow(userID: String, completion: @escaping (Result<Void>) -> Void)
    
    func cancelPending(userID: String, completion: @escaping (Result<Void>) -> Void)
    
    func unblock(userID: String, completion: @escaping (Result<Void>) -> Void)
    
    func block(userID: String, completion: @escaping (Result<Void>) -> Void)
}

struct SocialService: SocialServiceType {
    
    func follow(userID: String, completion: @escaping (Result<Void>) -> Void) {
        let request = PostFollowerRequest()
        request.userHandle = userID
        
        SocialAPI.myFollowersPostFollower(request: request) { data, error in
            if data != nil {
                completion(.success())
            } else {
                completion(.failure(APIError(error: error as? ErrorResponse)))
            }
        }
    }
    
    func unfollow(userID: String, completion: @escaping (Result<Void>) -> Void) {
        completion(.success())
    }
    
    func cancelPending(userID: String, completion: @escaping (Result<Void>) -> Void) {
        completion(.success())
    }
    
    func unblock(userID: String, completion: @escaping (Result<Void>) -> Void) {
        completion(.success())
    }
    
    func block(userID: String, completion: @escaping (Result<Void>) -> Void) {
        completion(.success())
    }
}
