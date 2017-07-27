//
//  UserProfileInteractor.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/27/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

final class UserProfileInteractor: UserProfileInteractorInput {
    private let userService: UserServiceType
    private let socialService: SocialServiceType
    
    init(userService: UserServiceType, socialService: SocialServiceType) {
        self.userService = userService
        self.socialService = socialService
    }
    
    func getUser(userID: String, completion: @escaping (Result<User>) -> Void) {
        userService.getUserProfile(userID: userID, completion: completion)
    }

    func getRecentPosts(userID: String, completion: @escaping (Result<[Any]>) -> Void) {
        completion(.success([]))
    }
    
    func getPopularPosts(userID: String, completion: @escaping (Result<[Any]>) -> Void) {
        completion(.success([]))
    }
    
    func getMyRecentPosts(completion: @escaping (Result<[Any]>) -> Void) {
        completion(.success([]))
    }
    
    func getMyPopularPosts(completion: @escaping (Result<[Any]>) -> Void) {
        completion(.success([]))
    }
    
    func follow(userID: String, completion: @escaping (Result<Void>) -> Void) {
        socialService.follow(userID: userID, completion: completion)
    }
    
    func unfollow(userID: String, completion: @escaping (Result<Void>) -> Void) {
        socialService.unfollow(userID: userID, completion: completion)
    }
    
    func cancelPending(userID: String, completion: @escaping (Result<Void>) -> Void) {
        socialService.cancelPending(userID: userID, completion: completion)
    }
    
    func unblock(userID: String, completion: @escaping (Result<Void>) -> Void) {
        socialService.unblock(userID: userID, completion: completion)
    }
    
    func block(userID: String, completion: @escaping (Result<Void>) -> Void) {
        socialService.block(userID: userID, completion: completion)
    }
}
