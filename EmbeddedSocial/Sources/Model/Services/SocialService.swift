//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol SocialServiceType {
    func follow(userID: String, completion: @escaping (Result<Void>) -> Void)
    
    func unfollow(userID: String, completion: @escaping (Result<Void>) -> Void)
    
    func cancelPending(userID: String, completion: @escaping (Result<Void>) -> Void)
    
    func unblock(userID: String, completion: @escaping (Result<Void>) -> Void)
    
    func block(userID: String, completion: @escaping (Result<Void>) -> Void)
    
    func request(currentFollowStatus: FollowStatus, userID: String, completion: @escaping (Result<Void>) -> Void)
    
    /// Get the feed of users that follow me
    func getMyFollowers(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void)
    
    /// Get the feed of users that I am following
    func getMyFollowing(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void)
    
    /// Get followers of a user
    func getUserFollowers(userID: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void)
    
    /// Get following users of a user
    func getUserFollowing(userID: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void)
}

struct SocialService: SocialServiceType {
    
    func follow(userID: String, completion: @escaping (Result<Void>) -> Void) {
        let request = PostFollowingUserRequest()
        request.userHandle = userID
        
        SocialAPI.myFollowingPostFollowingUser(request: request) { data, error in
            self.processResponse(data, error, completion)
        }
    }
    
    func unfollow(userID: String, completion: @escaping (Result<Void>) -> Void) {
        SocialAPI.myFollowingDeleteFollowingUser(userHandle: userID) { data, error in
            self.processResponse(data, error, completion)
        }
    }
    
    func cancelPending(userID: String, completion: @escaping (Result<Void>) -> Void) {
        completion(.success())
    }
    
    func unblock(userID: String, completion: @escaping (Result<Void>) -> Void) {
        completion(.success())
    }
    
    func block(userID: String, completion: @escaping (Result<Void>) -> Void) {
        let request = PostBlockedUserRequest()
        request.userHandle = userID
        
        SocialAPI.myBlockedUsersPostBlockedUser(request: request) { data, error in
            self.processResponse(data, error, completion)
        }
    }
    
    private func processResponse(_ data: Object?,_ error: Error?, _ completion: @escaping (Result<Void>) -> Void) {
        if error == nil {
            completion(.success())
        } else {
            completion(.failure(APIError(error: error as? ErrorResponse)))
        }
    }
    
    func getMyFollowing(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        SocialAPI.myFollowingGetFollowingUsers(cursor: cursor, limit: Int32(limit)) { response, error in
            if let response = response {
                let users = response.data?.map(User.init) ?? []
                completion(.success(UsersListResponse(users: users, cursor: response.cursor)))
            } else {
                completion(.failure(APIError(error: error as? ErrorResponse)))
            }
        }
    }
    
    func getMyFollowers(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        SocialAPI.myFollowersGetFollowers(cursor: cursor, limit: Int32(limit)) { response, error in
            if let response = response {
                let users = response.data?.map(User.init) ?? []
                completion(.success(UsersListResponse(users: users, cursor: response.cursor)))
            } else {
                completion(.failure(APIError(error: error as? ErrorResponse)))
            }
        }
    }
    
    func getUserFollowers(userID: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        SocialAPI.userFollowersGetFollowers(userHandle: userID, cursor: cursor, limit: Int32(limit)) { response, error in
            if let response = response {
                let users = response.data?.map(User.init) ?? []
                completion(.success(UsersListResponse(users: users, cursor: response.cursor)))
            } else {
                completion(.failure(APIError(error: error as? ErrorResponse)))
            }
        }
    }
    
    func getUserFollowing(userID: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        SocialAPI.userFollowingGetFollowing(userHandle: userID, cursor: cursor, limit: Int32(limit)) { response, error in
            if let response = response {
                let users = response.data?.map(User.init) ?? []
                completion(.success(UsersListResponse(users: users, cursor: response.cursor)))
            } else {
                completion(.failure(APIError(error: error as? ErrorResponse)))
            }
        }
    }
    
    func request(currentFollowStatus: FollowStatus, userID: String, completion: @escaping (Result<Void>) -> Void) {
        switch currentFollowStatus {
        case .empty:
            follow(userID: userID, completion: completion)
        case .accepted:
            unfollow(userID: userID, completion: completion)
        case .blocked:
            unblock(userID: userID, completion: completion)
        case .pending:
            cancelPending(userID: userID, completion: completion)
        }
    }
}
