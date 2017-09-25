//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol SocialServiceType {
    func follow(user: User, completion: @escaping (Result<Void>) -> Void)
    
    func unfollow(user: User, completion: @escaping (Result<Void>) -> Void)
    
    func cancelPending(user: User, completion: @escaping (Result<Void>) -> Void)
    
    func unblock(user: User, completion: @escaping (Result<Void>) -> Void)
    
    func block(user: User, completion: @escaping (Result<Void>) -> Void)
    
    func changeFollowStatus(user: User, completion: @escaping (Result<Void>) -> Void)
    
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
    
    private var usersFeedExecutor: UsersFeedRequestExecutor!
    private var suggestedUsersExecutor: SuggestedUsersRequestExecutor!
    private var outgoingActionsExecutor: OutgoingActionRequestExecutor!
    
    private let executorProvider: CacheRequestExecutorProviderType.Type
    
    init(executorProvider provider: CacheRequestExecutorProviderType.Type = CacheRequestExecutorProvider.self) {
        self.executorProvider = provider
        super.init()
        usersFeedExecutor = provider.makeUsersFeedExecutor(for: self)
        suggestedUsersExecutor = provider.makeSuggestedUsersExecutor(for: self)
        outgoingActionsExecutor = provider.makeOutgoingActionRequestExecutor(for: self)
    }
    
    func follow(user: User, completion: @escaping (Result<Void>) -> Void) {
        let request = PostFollowingUserRequest()
        request.userHandle = user.uid
        
        let builder = SocialAPI.myFollowingPostFollowingUserWithRequestBuilder(request: request, authorization: authorization)
        let command = FollowCommand(user: user)
        outgoingActionsExecutor.execute(command: command, builder: builder, completion: completion)
    }
    
    func unfollow(user: User, completion: @escaping (Result<Void>) -> Void) {
        let builder = SocialAPI.myFollowingDeleteFollowingUserWithRequestBuilder(userHandle: user.uid, authorization: authorization)
        let command = UnfollowCommand(user: user)
        outgoingActionsExecutor.execute(command: command, builder: builder, completion: completion)
    }
    
    func cancelPending(user: User, completion: @escaping (Result<Void>) -> Void) {
        let builder = SocialAPI.myPendingUsersDeletePendingUserWithRequestBuilder(userHandle: user.uid, authorization: authorization)
        let command = CancelPendingCommand(user: user)
        outgoingActionsExecutor.execute(command: command, builder: builder, completion: completion)
    }

    func unblock(user: User, completion: @escaping (Result<Void>) -> Void) {
        let builder =
            SocialAPI.myBlockedUsersDeleteBlockedUserWithRequestBuilder(userHandle: user.uid, authorization: authorization)
        let command = UnblockCommand(user: user)
        outgoingActionsExecutor.execute(command: command, builder: builder, completion: completion)
     }
    
    func block(user: User, completion: @escaping (Result<Void>) -> Void) {
        let request = PostBlockedUserRequest()
        request.userHandle = user.uid
        
        let builder = SocialAPI.myBlockedUsersPostBlockedUserWithRequestBuilder(request: request, authorization: authorization)
        let command = BlockCommand(user: user)
        outgoingActionsExecutor.execute(command: command, builder: builder, completion: completion)
    }
    
    private func processResponse(_ data: Object?, _ error: Error?, _ completion: @escaping (Result<Void>) -> Void) {
        DispatchQueue.main.async {
            if error == nil {
                completion(.success())
            } else {
                self.errorHandler.handle(error: error, completion: completion)
            }
        }
    }
    
    func getMyFollowing(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        let builder = SocialAPI.myFollowingGetFollowingUsersWithRequestBuilder(
            authorization: authorization,
            cursor: cursor,
            limit: Int32(limit)
        )
        
        let executor = executorProvider.makeMyFollowingExecutor(for: self)
        
        executor.execute(with: builder) { result in
            withExtendedLifetime(executor) {
                completion(result)
            }
        }
    }
    
    func getMyFollowers(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        let builder = SocialAPI.myFollowersGetFollowersWithRequestBuilder(
            authorization: authorization,
            cursor: cursor,
            limit: Int32(limit)
        )
        usersFeedExecutor.execute(with: builder, completion: completion)
    }
    
    func getUserFollowers(userID: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        let builder = SocialAPI.userFollowersGetFollowersWithRequestBuilder(
            userHandle: userID,
            authorization: authorization,
            cursor: cursor,
            limit: Int32(limit)
        )
        usersFeedExecutor.execute(with: builder, completion: completion)
    }
    
    func getUserFollowing(userID: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        let builder = SocialAPI.userFollowingGetFollowingWithRequestBuilder(
            userHandle: userID,
            authorization: authorization,
            cursor: cursor,
            limit: Int32(limit)
        )
        usersFeedExecutor.execute(with: builder, completion: completion)
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
        
        let executor = executorProvider.makeMyBlockedUsersExecutor(for: self)
        
        executor.execute(with: builder) { result in
            withExtendedLifetime(executor) {
                completion(result)
            }
        }
    }
    
    func changeFollowStatus(user: User, completion: @escaping (Result<Void>) -> Void) {
        guard let followStatus = user.followerStatus else {
            completion(.failure(APIError.missingUserData))
            return
        }
        
        switch followStatus {
        case .empty:
            follow(user: user, completion: completion)
        case .accepted:
            unfollow(user: user, completion: completion)
        case .blocked:
            unblock(user: user, completion: completion)
        case .pending:
            cancelPending(user: user, completion: completion)
        }
    }
    
    func getSuggestedUsers(completion: @escaping (Result<UsersListResponse>) -> Void) {
        let builder = SocialAPI.myFollowingGetSuggestionsUsersWithRequestBuilder(authorization: authorization)
        suggestedUsersExecutor.execute(with: builder, completion: completion)
    }
}

extension SocialService: ActivityService {
    
    func loadOthersActivities(cursor: String?, limit: Int, completion: @escaping (Result<FeedResponseActivityView>) -> Void) {
        let builder = SocialAPI.myFollowingGetActivitiesWithRequestBuilder(authorization: authorization, cursor: cursor, limit: Int32(limit))
        
        let key = builder.URLString
        
        if let cached = self.fetchFromCache(by: key) {
//            completion(.success(cached))
        }
        
        builder.execute { [weak self] (response, error) in
            
            guard let strongSelf = self else { return }
            
            guard let data = response?.body else {
                completion(.failure(APIError.missingUserData))
                return
            }
            
            strongSelf.cacheResponse(data, forKey: key)
            
            completion(.success(data))
        }
        
    }
    
    func loadMyActivities(cursor: String?, limit: Int, completion: @escaping (Result<FeedResponseActivityView>) -> Void) {
        
        let builder = NotificationsAPI.myNotificationsGetNotificationsWithRequestBuilder(authorization: authorization,
                                                                           cursor: cursor,
                                                                           limit: Int32(limit))
        
        let key = builder.URLString
        
        builder.execute { [weak self]  (response, error) in
            
            guard let strongSelf = self else { return }
            
            guard let data = response?.body else {
                completion(.failure(APIError.missingUserData))
                return
            }
            
            strongSelf.cacheResponse(data, forKey: key)
            
            completion(.success(data))
        }
    
    }
    
    func loadPendingsRequests(cursor: String?, limit: Int, completion: @escaping (Result<FeedResponseUserCompactView>) -> Void) {
        
    }
    
    func approvePendingRequest(handle: String, completion: @escaping (Result<Void>) -> Void) {
        
    }
    
    func rejectPendingRequest(handle: String, completion: @escaping (Result<Void>) -> Void) {
        
    }
    
    
    func acceptFollowRequest(for userHandle: String, completion: @escaping (Result<Void>) -> Void) {
        
        let request = PostFollowerRequest()
        request.userHandle = userHandle
        
        let builder = SocialAPI.myFollowersPostFollowerWithRequestBuilder(request: request, authorization: authorization)
        
        
        
        //        let command = AcceptFollowRequestCommand(user: user)
        //        let builder = SocialAPI.ac
        //        outgoingActionsExecutor.execute(command: command, builder: builder, completion: completion)
    }
    
    private func cacheResponse(_ response: FeedResponseActivityView, forKey key: String) {
        cache.cacheIncoming(response, for: key)
    }
    
    private func fetchFromCache(by cacheKey: String) -> FeedResponseActivityView? {
        return cache.firstIncoming(ofType: FeedResponseActivityView.self, typeID: cacheKey)
    }
}

