//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol SearchServiceType {
    func queryUsers(query: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void)
}

final class SearchService: BaseService, SearchServiceType {
    
    typealias UsersFeedRequestExecutor = CacheRequestExecutionStrategy<FeedResponseUserCompactView, UsersListResponse>
    
    let requestExecutor: UsersFeedRequestExecutor

    init(requestExecutor: UsersFeedRequestExecutor = UsersFeedRequestExecutionStrategy()) {
        self.requestExecutor = requestExecutor
        
        super.init()
        
        self.requestExecutor.cache = cache
        self.requestExecutor.errorHandler = errorHandler
    }
    
    func queryUsers(query: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        let builder = SearchAPI.searchGetUsersWithRequestBuilder(query: query,
                                                                 authorization: authorization,
                                                                 cursor: Int32(cursor ?? ""),
                                                                 limit: Int32(limit))
        requestExecutor.execute(with: builder, completion: completion)
    }
}
