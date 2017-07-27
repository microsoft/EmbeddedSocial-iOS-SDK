//
//  UserProfileInteractorInput.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/27/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

protocol UserProfileInteractorInput {    
    func getUser(userID: String, completion: @escaping (Result<User>) -> Void)
        
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
