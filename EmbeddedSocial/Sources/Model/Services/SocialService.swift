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
    
    func getSuggestedUsers(completion: @escaping (Result<UsersListResponse>) -> Void)
    
    /// Get the feed of users that follow me
    func getMyFollowers(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void)
    
    /// Get the feed of users that I am following
    func getMyFollowing(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void)
    
    /// Get followers of a user
    func getUserFollowers(userID: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void)
    
    /// Get following users of a user
    func getUserFollowing(userID: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void)
    
    /// Hide for post
    func deletePostFromMyFollowing(postID: String, completion: @escaping (Result<Void>) -> Void)
    
    /// Get my blocked users
    func getMyBlockedUsers(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void)
}

class SocialService: BaseService, SocialServiceType {
    
    func follow(userID: String, completion: @escaping (Result<Void>) -> Void) {
        let request = PostFollowingUserRequest()
        request.userHandle = userID
        
        SocialAPI.myFollowingPostFollowingUser(request: request, authorization: authorization) { data, error in
            self.processResponse(data, error, completion)
        }
    }
    
    func unfollow(userID: String, completion: @escaping (Result<Void>) -> Void) {
        SocialAPI.myFollowingDeleteFollowingUser(userHandle: userID, authorization: authorization) { data, error in
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
        
        SocialAPI.myBlockedUsersPostBlockedUser(request: request, authorization: authorization) { data, error in
            self.processResponse(data, error, completion)
        }
    }
    
    private func processResponse(_ data: Object?, _ error: Error?, _ completion: @escaping (Result<Void>) -> Void) {
        if error == nil {
            completion(.success())
        } else {
            errorHandler.handle(error: error, completion: completion)
        }
    }
    
    func getMyFollowing(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        SocialAPI.myFollowingGetFollowingUsers(authorization: authorization, cursor: cursor, limit: Int32(limit)) {
            self.processUserFeedResponse(response: $0, error: $1, completion: completion)
        }
    }
    
    func getMyFollowers(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        let builder = SocialAPI.myFollowersGetFollowersWithRequestBuilder(
            authorization: authorization,
            cursor: cursor,
            limit: Int32(limit)
        )
        
        executeRequest(with: builder, completion: completion)
    }
    
    func getUserFollowers(userID: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        SocialAPI.userFollowersGetFollowers(
            userHandle: userID,
            authorization: authorization,
            cursor: cursor,
            limit: Int32(limit)) {
                self.processUserFeedResponse(response: $0, error: $1, completion: completion)
        }
    }
    
    func getUserFollowing(userID: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        SocialAPI.userFollowingGetFollowing(
            userHandle: userID,
            authorization: authorization,
            cursor: cursor,
            limit: Int32(limit)) {
                self.processUserFeedResponse(response: $0, error: $1, completion: completion)
        }
    }
    
    func deletePostFromMyFollowing(postID: String, completion: @escaping (Result<Void>) -> Void) {
        SocialAPI.myFollowingDeleteFollowingTopic(topicHandle: postID,
                                                  authorization: authorization) { (object, errorResponse) in
                                                    
                                                    if let error = errorResponse {
                                                        self.errorHandler.handle(error: error, completion: completion)
                                                    } else {
                                                        completion(.success())
                                                    }
        }
    }
    
    func getMyBlockedUsers(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        let builder = SocialAPI.myBlockedUsersGetBlockedUsersWithRequestBuilder(
            authorization: authorization,
            cursor: cursor,
            limit: Int32(limit)
        )
        
        executeRequest(with: builder, completion: completion)
    }
    
    private func executeRequest(with builder: RequestBuilder<FeedResponseUserCompactView>,
                                completion: @escaping (Result<UsersListResponse>) -> Void) {
        
        if let cachedResponse = cache.firstIncoming(ofType: FeedResponseUserCompactView.self, handle: builder.URLString) {
            processUserFeedResponse(response: cachedResponse, error: nil, completion: completion)
        }
        
        builder.execute { [weak self] result, error in
            let response = result?.body
            response?.setHandle(builder.URLString)
            if let response = response {
                self?.cache.cacheIncoming(response)
            }
            self?.processUserFeedResponse(response: response, error: error, completion: completion)
        }
    }
    
    private func processUserFeedResponse(response: FeedResponseUserCompactView?,
                                         error: Error?,
                                         completion: @escaping (Result<UsersListResponse>) -> Void) {
        if let response = response {
            let users = response.data?.map(User.init) ?? []
            completion(.success(UsersListResponse(users: users, cursor: response.cursor)))
        } else {
            errorHandler.handle(error: error, completion: completion)
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
    
    func getSuggestedUsers(completion: @escaping (Result<UsersListResponse>) -> Void) {
        SocialAPI.myFollowingGetSuggestionsUsers(authorization: authorization) { responseUsers, error in
            if let responseUsers = responseUsers {
                let users = responseUsers.map(User.init)
                completion(.success(UsersListResponse(users: users, cursor: nil)))
            } else {
                self.errorHandler.handle(error: error, completion: completion)
            }
        }
    }
}
