//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

typealias SuggestedUsersRequestExecutor = IncomingCacheRequestExecutor<[UserCompactView], UsersListResponse>

class SuggestedUsersRequestExecutorImpl: IncomingCacheRequestExecutor<[UserCompactView], UsersListResponse> {
    
    override func execute(with builder: RequestBuilder<[UserCompactView]>,
                          completion: @escaping (Result<UsersListResponse>) -> Void) {
        
        let p = PredicateBuilder().predicate(typeID: builder.URLString)
        let cacheRequest = CacheFetchRequest(resultType: UserCompactView.self, predicate: p, sortDescriptors: [Cache.createdAtSortDescriptor])
        
        cache?.fetchIncoming(with: cacheRequest) { responseUsers in
            let users = responseUsers.map(User.init)
            let response = UsersListResponse(items: users, cursor: nil, isFromCache: true)
            DispatchQueue.main.async {
                completion(.success(response))
            }
        }
        
        builder.execute { [weak self] result, error in
            guard error == nil else {
                self?.errorHandler?.handle(error: error, completion: completion)
                return
            }
            result?.body?.forEach { self?.cache?.cacheIncoming($0, for: builder.URLString) }
            let users = result?.body?.map(User.init) ?? []
            let response = UsersListResponse(items: users, cursor: nil, isFromCache: false)
            DispatchQueue.main.async {
                completion(.success(response))
            }
        }
    }
}
