//
//  SocialService.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/27/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

protocol SocialServiceType {
    func follow(userID: String, completion: (Result<Void>) -> Void)
    
    func unfollow(userID: String, completion: (Result<Void>) -> Void)
    
    func cancelPending(userID: String, completion: (Result<Void>) -> Void)
    
    func unblock(userID: String, completion: (Result<Void>) -> Void)
    
    func block(userID: String, completion: (Result<Void>) -> Void)
}

struct SocialService: SocialServiceType {
    
    func follow(userID: String, completion: (Result<Void>) -> Void) {
        completion(.success())
    }
    
    func unfollow(userID: String, completion: (Result<Void>) -> Void) {
        completion(.success())
    }
    
    func cancelPending(userID: String, completion: (Result<Void>) -> Void) {
        completion(.success())
    }
    
    func unblock(userID: String, completion: (Result<Void>) -> Void) {
        completion(.success())
    }
    
    func block(userID: String, completion: (Result<Void>) -> Void) {
        completion(.success())
    }
}
