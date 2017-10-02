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
    private(set) var changeFollowStatusCount = 0
    private(set) var getMyBlockedUsersCount = 0

    var followInputUser: User?
    
    func follow(user: User, completion: @escaping (Result<Void>) -> Void) {
        followCount += 1
        followInputUser = user
        completion(.success())
    }
    
    var unfollowInputUser: User?
    
    func unfollow(user: User, completion: @escaping (Result<Void>) -> Void) {
        unfollowCount += 1
        unfollowInputUser = user
        completion(.success())
    }
    
    var cancelPendingInputUser: User?
    
    func cancelPending(user: User, completion: @escaping (Result<Void>) -> Void) {
        cancelPendingCount += 1
        cancelPendingInputUser = user
        completion(.success())
    }
    
    func unblock(user: User, completion: @escaping (Result<Void>) -> Void) {
        unblockCount += 1
        completion(.success())
    }
    
    var blockInputUser: User?
    
    func block(user: User, completion: @escaping (Result<Void>) -> Void) {
        blockCount += 1
        blockInputUser = user
        completion(.success())
    }
    
    func getMyFollowers(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        getMyFollowersCount += 1
        completion(.success(UsersListResponse(users: [], cursor: nil, isFromCache: false)))
    }
    
    func getMyFollowing(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        getMyFollowingCount += 1
        completion(.success(UsersListResponse(users: [], cursor: nil, isFromCache: false)))
    }
    
    func getUserFollowers(userID: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        getUserFollowersCount += 1
        completion(.success(UsersListResponse(users: [], cursor: nil, isFromCache: false)))
    }
    
    func getUserFollowing(userID: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        getUserFollowingCount += 1
        completion(.success(UsersListResponse(users: [], cursor: nil, isFromCache: false)))
    }
    
    func changeFollowStatus(user: User, completion: @escaping (Result<Void>) -> Void) {
        changeFollowStatusCount += 1
        completion(.success())
    }
    
    func deletePostFromMyFollowing(postID: String, completion: @escaping (Result<Void>) -> Void) {
        
    }
    
    var getSuggestedUsersCalled = false
    var getSuggestedUsersInputAuthorization: Authorization?
    var getSuggestedUsersReturnValue: Result<UsersListResponse>!
    
    func getSuggestedUsers(authorization: Authorization, completion: @escaping (Result<UsersListResponse>) -> Void) {
        getSuggestedUsersCalled = true
        getSuggestedUsersInputAuthorization = authorization
        completion(getSuggestedUsersReturnValue)
    }
    
    func getMyBlockedUsers(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        getMyBlockedUsersCount += 1
        completion(.success(UsersListResponse(users: [], cursor: nil, isFromCache: false)))
    }
    
    
    var acceptPendingCalled = false
    var acceptPendingInputUser: User?
    var acceptPendingReturnResult: Result<Void>!
    
    func acceptPending(user: User, completion: @escaping (Result<Void>) -> Void) {
        acceptPendingCalled = true
        acceptPendingInputUser = user
        completion(acceptPendingReturnResult)
    }
    
    func getMyPendingRequests(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        
    }
}
