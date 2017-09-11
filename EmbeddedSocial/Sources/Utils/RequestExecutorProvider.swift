//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

typealias UsersFeedRequestExecutor = CacheRequestExecutionStrategy<FeedResponseUserCompactView, UsersListResponse>

typealias TopicsFeedRequestExecutor = CacheRequestExecutionStrategy<FeedResponseTopicView, FeedFetchResult>

typealias SuggestedUsersRequestExecutor = CacheRequestExecutionStrategy<[UserCompactView], UsersListResponse>

protocol CacheRequestExecutorProviderType {
    static func makeUsersFeedExecutor(for service: BaseService) -> UsersFeedRequestExecutor
    
    static func makeTopicsFeedExecutor(for service: BaseService) -> TopicsFeedRequestExecutor
    
    static func makeSuggestedUsersExecutor(for service: BaseService) -> SuggestedUsersRequestExecutor
}

struct CacheRequestExecutorProvider: CacheRequestExecutorProviderType {

    static func makeUsersFeedExecutor(for service: BaseService) -> UsersFeedRequestExecutor {
        let executor = makeCommonExecutor(requestType: FeedResponseUserCompactView.self,
                                          responseType: UsersListResponse.self,
                                          service: service)
        executor.mapper = { UsersListResponse(response: $0, isFromCache: false) }
        executor.cacheMapper = { UsersListResponse(response: $0, isFromCache: true) }
        return executor
    }
    
    static func makeTopicsFeedExecutor(for service: BaseService) -> TopicsFeedRequestExecutor {
        let executor = makeCommonExecutor(requestType: FeedResponseTopicView.self,
                                          responseType: FeedFetchResult.self,
                                          service: service)
        executor.mapper = FeedFetchResult.init
        executor.cacheMapper = FeedFetchResult.init
        return executor
    }
    
    static func makeSuggestedUsersExecutor(for service: BaseService) -> SuggestedUsersRequestExecutor {
        let executor = SuggestedUsersRequestExecutionStrategy()
        bind(service: service, to: executor)
        return executor
    }
    
    private static func makeCommonExecutor<T: Cacheable, U>(requestType: T.Type,
                                           responseType: U.Type,
                                           service: BaseService) -> CommonCacheRequestExecutionStrategy<T, U> {
        
        let executor = CommonCacheRequestExecutionStrategy<T, U>()
        bind(service: service, to: executor)
        return executor
    }
    
    private static func bind<T, U>(service: BaseService, to executor: CacheRequestExecutionStrategy<T, U>) {
        executor.cache = service.cache
        executor.errorHandler = service.errorHandler
    }
}
