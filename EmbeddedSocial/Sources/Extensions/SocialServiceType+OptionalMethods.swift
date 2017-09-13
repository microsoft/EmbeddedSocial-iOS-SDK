//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

extension SocialServiceType {
    func follow(user: User, completion: @escaping (Result<Void>) -> Void) {
        Logger.log("No Implementation")
    }
    
    func unfollow(user: User, completion: @escaping (Result<Void>) -> Void) {
        Logger.log("No Implementation")
    }
    
    func cancelPending(user: User, completion: @escaping (Result<Void>) -> Void) {
        Logger.log("No Implementation")
    }
    
    func unblock(user: User, completion: @escaping (Result<Void>) -> Void) {
        Logger.log("No Implementation")
    }
    
    func block(user: User, completion: @escaping (Result<Void>) -> Void) {
        Logger.log("No Implementation")
    }
    
    func changeFollowStatus(user: User, completion: @escaping (Result<Void>) -> Void) {
        Logger.log("No Implementation")
    }
    
    func getMyFollowers(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        Logger.log("No Implementation")
    }
    
    func getMyFollowing(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        Logger.log("No Implementation")
    }
    
    func getUserFollowers(userID: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        Logger.log("No Implementation")
    }
    
    func getUserFollowing(userID: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        Logger.log("No Implementation")
    }
    
    func deletePostFromMyFollowing(postID: String, completion: @escaping (Result<Void>) -> Void) {
        Logger.log("No Implementation")
    }
    
    func getSuggestedUsers(completion: @escaping (Result<UsersListResponse>) -> Void) {
        Logger.log("No Implementation")
    }
    
    func getMyBlockedUsers(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        Logger.log("No Implementation")
    }
}
