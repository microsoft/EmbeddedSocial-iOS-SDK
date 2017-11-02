//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol SocialServiceType {
    func follow(user: User, completion: @escaping (Result<Void>) -> Void)
    
    func unfollow(user: User, completion: @escaping (Result<Void>) -> Void)
    
    func cancelPending(user: User, completion: @escaping (Result<Void>) -> Void)
    
    func acceptPending(user: User, completion: @escaping (Result<Void>) -> Void)

    func unblock(user: User, completion: @escaping (Result<Void>) -> Void)
    
    func block(user: User, completion: @escaping (Result<Void>) -> Void)
    
    func changeFollowStatus(user: User, completion: @escaping (Result<Void>) -> Void)
    
    func getSuggestedUsers(authorization: Authorization, completion: @escaping (Result<UsersListResponse>) -> Void)
    
    func getMyFollowers(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void)
    
    func getMyFollowing(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void)
    
    func getUserFollowers(userID: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void)
    
    func getUserFollowing(userID: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void)
    
    func deletePostFromMyFollowing(postID: String, completion: @escaping (Result<Void>) -> Void)
    
    func getMyBlockedUsers(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void)
    
    func getMyPendingRequests(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void)
    
    func getPopularUsers(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void)
}

class SocialService: BaseService, SocialServiceType {
    
    fileprivate var usersFeedExecutor: UsersFeedRequestExecutor!
    private var suggestedUsersExecutor: SuggestedUsersRequestExecutor!
    private var outgoingActionsExecutor: OutgoingActionRequestExecutor!
    fileprivate var activitiesExecutor: MyActivityRequestExecutor!
    
    fileprivate let executorProvider: CacheRequestExecutorProviderType.Type
    
    init(executorProvider provider: CacheRequestExecutorProviderType.Type = CacheRequestExecutorProvider.self) {
        self.executorProvider = provider
        super.init()
        usersFeedExecutor = provider.makeUsersFeedExecutor(for: self)
        suggestedUsersExecutor = provider.makeSuggestedUsersExecutor(for: self)
        outgoingActionsExecutor = provider.makeOutgoingActionRequestExecutor(for: self)
        activitiesExecutor = provider.makeMyActivityExecutor(for: self)
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
    
    func acceptPending(user: User, completion: @escaping (Result<Void>) -> Void) {
        let request = PostFollowerRequest()
        request.userHandle = user.uid
        
        let builder = SocialAPI.myFollowersPostFollowerWithRequestBuilder(request: request, authorization: authorization)
        let command = AcceptPendingCommand(user: user)
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
        
        let executor = executorProvider.makeMyFollowersExecutor(for: self)
        
        executor.execute(with: builder) { result in
            withExtendedLifetime(executor) {
                completion(result)
            }
        }
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
    
    func getSuggestedUsers(authorization: Authorization, completion: @escaping (Result<UsersListResponse>) -> Void) {
        let builder = SocialAPI.myFollowingGetSuggestionsUsersWithRequestBuilder(authorization: authorization)
        suggestedUsersExecutor.execute(with: builder, completion: completion)
    }
    
    func getMyPendingRequests(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        let builder = SocialAPI.myPendingUsersGetPendingUsersWithRequestBuilder(
            authorization: authorization,
            cursor: cursor,
            limit: Int32(limit)
        )
        
        let executor = executorProvider.makeMyPendingRequestsExecutor(for: self)
        
        executor.execute(with: builder) { result in
            withExtendedLifetime(executor) {
                completion(result)
            }
        }
    }
    
    func getPopularUsers(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        let builder = UsersAPI.usersGetPopularUsersWithRequestBuilder(
            authorization: authorization,
            cursor: Int32(cursor ?? ""),
            limit: Int32(limit)
        )
        
        let executor = executorProvider.makePopularUsersExecutor(for: self)
        
        executor.execute(with: builder) { result in
            withExtendedLifetime(executor) {
                completion(result)
            }
        }
    }
}

extension SocialService: ActivityService {
    
    func loadMyActivities(cursor: String?, limit: Int, completion: @escaping (ActivityItemListResult) -> Void) {
        let builder = NotificationsAPI.myNotificationsGetNotificationsWithRequestBuilder(authorization: authorization,
                                                                                         cursor: cursor,
                                                                                         limit: Int32(limit))
        activitiesExecutor.execute(with: builder) {
            completion($0)
        }
    }
    
    func loadOthersActivities(cursor: String?, limit: Int, completion: @escaping (ActivityItemListResult) -> Void) {
        let builder = SocialAPI.myFollowingGetActivitiesWithRequestBuilder(authorization: authorization, cursor: cursor, limit: Int32(limit))
        
        activitiesExecutor.execute(with: builder) {
            completion($0)
        }
    }
    
    func loadPendingsRequests(cursor: String?, limit: Int, completion: @escaping (UserRequestListResult) -> Void) {
        getMyPendingRequests(cursor: cursor, limit: limit, completion: completion)
    }
}

