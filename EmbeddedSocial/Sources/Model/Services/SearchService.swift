//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol SearchServiceType {
    func queryUsers(query: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void)
    func queryTopics(query: String, cursor: String?, limit: Int, completion: @escaping (Result<PostFetchResult>) -> Void)
}

final class SearchService: BaseService, SearchServiceType {
    
    private var usersRequestExecutor: UsersFeedRequestExecutor!
    private var topicsRequestExecutor: TopicsFeedRequestExecutor!

    init(requestExecutorProvider provider: CacheRequestExecutorProviderType.Type = CacheRequestExecutorProvider.self) {
        super.init()
        
        usersRequestExecutor = provider.makeUsersFeedExecutor(for: self)
        topicsRequestExecutor = provider.makeTopicsFeedExecutor(for: self)
    }
    
    func queryUsers(query: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        let builder = SearchAPI.searchGetUsersWithRequestBuilder(query: query,
                                                                 authorization: authorization,
                                                                 cursor: Int32(cursor ?? ""),
                                                                 limit: Int32(limit))
        usersRequestExecutor.execute(with: builder, completion: completion)
    }
    
    func queryTopics(query: String, cursor: String?, limit: Int, completion: @escaping (Result<PostFetchResult>) -> Void) {
        let builder = SearchAPI.searchGetTopicsWithRequestBuilder(
            query: query,
            authorization: authorization,
            cursor: Int32(cursor ?? ""),
            limit: Int32(limit))
        topicsRequestExecutor.execute(with: builder, completion: completion)
    }
}
