//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

typealias HashtagsRequestExecutor = IncomingCacheRequestExecutor<[String], PaginatedResponse<Hashtag>>

class HashtagsRequestExecutorImpl: IncomingCacheRequestExecutor<[String], PaginatedResponse<Hashtag>> {
    
    override func execute(with builder: RequestBuilder<[String]>,
                          completion: @escaping (Result<PaginatedResponse<Hashtag>>) -> Void) {
        
        let predicate = PredicateBuilder().predicate(typeID: builder.URLString)
        
        let cacheRequest = CacheFetchRequest(resultType: HashtagCacheableAdapter.self,
                                             predicate: predicate,
                                             sortDescriptors: [Cache.createdAtSortDescriptor])
        
        cache?.fetchIncoming(with: cacheRequest) { hashtagAdapters in
            let hashtags = hashtagAdapters.map { $0.hashtag }
            let response = PaginatedResponse<Hashtag>(items: hashtags, cursor: nil, isFromCache: true)
            DispatchQueue.main.async {
                completion(.success(response))
            }
        }
        
        builder.execute { [weak self] result, error in
            guard error == nil else {
                self?.errorHandler?.handle(error: error, completion: completion)
                return
            }
            self?.cache?.deleteIncoming(with: predicate)
            
            let hashtags = result?.body ?? []
            let hashtagAdapters = hashtags.map { HashtagCacheableAdapter(handle: UUID().uuidString, hashtag: $0) }
            hashtagAdapters.forEach { self?.cache?.cacheIncoming($0, for: builder.URLString) }
            
            let response = PaginatedResponse<Hashtag>(items: hashtags, cursor: nil, isFromCache: false)
            
            DispatchQueue.main.async {
                completion(.success(response))
            }
        }
    }

}
