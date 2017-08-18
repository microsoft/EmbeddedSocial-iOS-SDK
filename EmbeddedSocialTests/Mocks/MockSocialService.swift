//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockSocialService: SocialServiceType {
    private(set) var followCount = 0
    private(set) var unfollowCount = 0
    private(set) var cancelPendingCount = 0
    private(set) var unblockCount = 0
    private(set) var blockCount = 0
    private(set) var getMyFollowersCount = 0
    private(set) var getMyFollowingCount = 0
    private(set) var getUserFollowersCount = 0
    private(set) var getUserFollowingCount = 0
    private(set) var requestCount = 0
    private(set) var getSuggestedUsersCount = 0

    func follow(userID: String, completion: @escaping (Result<Void>) -> Void) {
        followCount += 1
        completion(.success())
    }
    
    func unfollow(userID: String, completion: @escaping (Result<Void>) -> Void) {
        unfollowCount += 1
        completion(.success())
    }
    
    func cancelPending(userID: String, completion: @escaping (Result<Void>) -> Void) {
        cancelPendingCount += 1
        completion(.success())
    }
    
    func unblock(userID: String, completion: @escaping (Result<Void>) -> Void) {
        unblockCount += 1
        completion(.success())
    }
    
    func block(userID: String, completion: @escaping (Result<Void>) -> Void) {
        blockCount += 1
        completion(.success())
    }
    
    func getMyFollowers(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        getMyFollowersCount += 1
        completion(.success(UsersListResponse(users: [], cursor: nil)))
    }
    
    func getMyFollowing(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        getMyFollowingCount += 1
        completion(.success(UsersListResponse(users: [], cursor: nil)))
    }
    
    func getUserFollowers(userID: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        getUserFollowersCount += 1
        completion(.success(UsersListResponse(users: [], cursor: nil)))
    }
    
    func getUserFollowing(userID: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        getUserFollowingCount += 1
        completion(.success(UsersListResponse(users: [], cursor: nil)))
    }
    
    func request(currentFollowStatus: FollowStatus, userID: String, completion: @escaping (Result<Void>) -> Void) {
        requestCount += 1
        completion(.success())
    }
    
    func deletePostFromMyFollowing(postID: String, completion: @escaping (Result<Void>) -> Void) {
        
    }
    
    func getSuggestedUsers(completion: @escaping (Result<UsersListResponse>) -> Void) {
        getSuggestedUsersCount += 1
        let response = UsersListResponse(users: [], cursor: nil)
        completion(.success(response))
    }
    
}
