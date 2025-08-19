//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class CacheRequestExecutorProvider: CacheRequestExecutorProviderType {
    
    static func makeUsersFeedExecutor(for service: BaseService) -> UsersFeedRequestExecutor {
        return makeCommonExecutor(requestType: FeedResponseUserCompactView.self,
                                  responseType: UsersListResponse.self,
                                  service: service,
                                  responseProcessor: UsersListResponseProcessor(cache: service.cache))
    }
    
    static func makeMyFollowingExecutor(for service: BaseService) -> UsersFeedRequestExecutor {
        return makeCommonExecutor(requestType: FeedResponseUserCompactView.self,
                                  responseType: UsersListResponse.self,
                                  service: service,
                                  responseProcessor: MyFollowingResponseProcessor(cache: service.cache))
    }
    
    static func makeMyBlockedUsersExecutor(for service: BaseService) -> UsersFeedRequestExecutor {
        return makeCommonExecutor(requestType: FeedResponseUserCompactView.self,
                                  responseType: UsersListResponse.self,
                                  service: service,
                                  responseProcessor: MyBlockedUsersResponseProcessor(cache: service.cache))
    }
    
    static func makeTopicsFeedExecutor(for service: BaseService) -> TopicsFeedRequestExecutor {
        return makeCommonExecutor(requestType: FeedResponseTopicView.self,
                                  responseType: FeedFetchResult.self,
                                  service: service,
                                  responseProcessor: TopicsFeedResponseProcessor(cache: service.cache))
    }
    
    static func makeMyRecentTopicsFeedExecutor(for service: BaseService) -> TopicsFeedRequestExecutor {
        return makeCommonExecutor(requestType: FeedResponseTopicView.self,
                                  responseType: FeedFetchResult.self,
                                  service: service,
                                  responseProcessor: MyRecentTopicsFeedResponseProcessor(cache: service.cache))
    }
    
    static func makeMyActivityExecutor(for service: BaseService) -> MyActivityRequestExecutor {
        return makeCommonExecutor(requestType: FeedResponseActivityView.self,
                                  responseType: PaginatedResponse<ActivityView>.self,
                                  service: service,
                                  responseProcessor: ActivityFeedProcessor())
    }
    
    static func makeSinglePostExecutor(for service: BaseService) -> SingleTopicRequestExecutor {
        return makeCommonExecutor(requestType: TopicView.self,
                                  responseType: Post.self,
                                  service: service,
                                  responseProcessor: SinglePostResponseProcessor(cache: service.cache))
    }
    
    static func makeSuggestedUsersExecutor(for service: BaseService) -> SuggestedUsersRequestExecutor {
        let executor = SuggestedUsersRequestExecutorImpl()
        bind(service: service, to: executor)
        return executor
    }
    
    class func makeAtomicOutgoingCommandsExecutor(for service: BaseService) -> AtomicOutgoingCommandsExecutor {
        let executor = AtomicOutgoingCommandsExecutorImpl()
        executor.cache = service.cache
        executor.errorHandler = service.errorHandler
        return executor
    }
    
    static func makeMyFollowersExecutor(for service: BaseService) -> UsersFeedRequestExecutor {
        return makeCommonExecutor(requestType: FeedResponseUserCompactView.self,
                                  responseType: UsersListResponse.self,
                                  service: service,
                                  responseProcessor: MyFollowersResponseProcessor(cache: service.cache))
    }
    
    static func makeMyPendingRequestsExecutor(for service: BaseService) -> UsersFeedRequestExecutor {
        return makeCommonExecutor(requestType: FeedResponseUserCompactView.self,
                                  responseType: UsersListResponse.self,
                                  service: service,
                                  responseProcessor: PendingRequestsResponseProcessor(cache: service.cache))
    }
    
    static func makeSearchTopicsFeedExecutor(for service: BaseService) -> TopicsFeedRequestExecutor {
        return makeCommonExecutor(requestType: FeedResponseTopicView.self,
                                  responseType: FeedFetchResult.self,
                                  service: service,
                                  responseProcessor: SearchTopicsFeedResponseProcessor(cache: service.cache))
    }
    
    static func makePopularUsersExecutor(for service: BaseService) -> PopularUsersRequestExecutor {
        return makeCommonExecutor(requestType: FeedResponseUserProfileView.self,
                                  responseType: UsersListResponse.self,
                                  service: service,
                                  responseProcessor: PopularUsersResponseProcessor())
    }
    
    static func makeHashtagsExecutor(for service: BaseService) -> HashtagsRequestExecutor {
        let executor = HashtagsRequestExecutorImpl()
        executor.cache = service.cache
        executor.errorHandler = service.errorHandler
        return executor
    }
    
    private static func makeCommonExecutor<T: Cacheable, U>(
        requestType: T.Type,
        responseType: U.Type,
        service: BaseService,
        responseProcessor: ResponseProcessor<T, U>) -> IncomingCacheRequestExecutor<T, U> {
        
        let executor = IncomingCacheRequestExecutorImpl<T, U>()
        bind(service: service, to: executor)
        executor.responseProcessor = responseProcessor
        return executor
    }
    
    private static func bind<T, U>(service: BaseService, to executor: IncomingCacheRequestExecutor<T, U>) {
        executor.cache = service.cache
        executor.errorHandler = service.errorHandler
        executor.networkTracker = service.networkStatusMulticast
    }
}
