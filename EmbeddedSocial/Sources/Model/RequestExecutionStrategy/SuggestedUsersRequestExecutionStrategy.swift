//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class SuggestedUsersRequestExecutionStrategy: CacheRequestExecutionStrategy<[UserCompactView], UsersListResponse> {
    
    override func execute(with builder: RequestBuilder<ResponseType>, completion: @escaping (Result<ResultType>) -> Void) {
        let p = PredicateBuilder().predicate(typeID: builder.URLString)
        let cacheRequest = CacheFetchRequest(resultType: UserCompactView.self, predicate: p, sortDescriptors: [Cache.createdAtSortDescriptor])
        
        cache?.fetchIncoming(with: cacheRequest) { responseUsers in
            let users = responseUsers.map(User.init)
            let response = UsersListResponse(users: users, cursor: nil, isFromCache: true)
            completion(.success(response))
        }
        
        builder.execute { [weak self] result, error in
            guard error == nil else {
                self?.errorHandler?.handle(error: error, completion: completion)
                return
            }
            result?.body?.forEach { self?.cache?.cacheIncoming($0, for: builder.URLString) }
            let users = result?.body?.map(User.init) ?? []
            let response = UsersListResponse(users: users, cursor: nil, isFromCache: false)
            completion(.success(response))
        }
    }
}
