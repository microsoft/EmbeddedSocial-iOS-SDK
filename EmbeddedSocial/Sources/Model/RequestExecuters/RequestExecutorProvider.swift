//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

typealias UsersFeedRequestExecutor = IncomingCacheRequestExecutor<FeedResponseUserCompactView, UsersListResponse>

typealias TopicsFeedRequestExecutor = IncomingCacheRequestExecutor<FeedResponseTopicView, FeedFetchResult>

typealias MyActivityRequestExecutor = IncomingCacheRequestExecutor<FeedResponseActivityView, PaginatedResponse<ActivityView> >

typealias OthersActivityRequestExecutor = IncomingCacheRequestExecutor<FeedResponseActivityView, PaginatedResponse<ActivityView> >

typealias SingleTopicRequestExecutor = IncomingCacheRequestExecutor<TopicView, Post>

typealias PopularUsersRequestExecutor = IncomingCacheRequestExecutor<FeedResponseUserProfileView, UsersListResponse>

protocol CacheRequestExecutorProviderType {
    static func makeUsersFeedExecutor(for service: BaseService) -> UsersFeedRequestExecutor
    
    static func makeTopicsFeedExecutor(for service: BaseService) -> TopicsFeedRequestExecutor
    
    static func makeSuggestedUsersExecutor(for service: BaseService) -> SuggestedUsersRequestExecutor
    
    static func makeAtomicOutgoingCommandsExecutor(for service: BaseService) -> AtomicOutgoingCommandsExecutor
    
    static func makeMyFollowingExecutor(for service: BaseService) -> UsersFeedRequestExecutor
    
    static func makeMyBlockedUsersExecutor(for service: BaseService) -> UsersFeedRequestExecutor
    
    static func makeMyActivityExecutor(for service: BaseService) -> MyActivityRequestExecutor
    
    static func makeSinglePostExecutor(for service: BaseService) -> SingleTopicRequestExecutor

    static func makeMyFollowersExecutor(for service: BaseService) -> UsersFeedRequestExecutor
    
    static func makeMyPendingRequestsExecutor(for service: BaseService) -> UsersFeedRequestExecutor
    
    static func makeMyRecentTopicsFeedExecutor(for service: BaseService) -> TopicsFeedRequestExecutor

    static func makeSearchTopicsFeedExecutor(for service: BaseService) -> TopicsFeedRequestExecutor
    
    static func makePopularUsersExecutor(for service: BaseService) -> PopularUsersRequestExecutor
    
    static func makeHashtagsExecutor(for service: BaseService) -> HashtagsRequestExecutor
}

