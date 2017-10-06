//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class HashtagsRequestExecutionStrategy: CacheRequestExecutionStrategy<[String], [Hashtag]> {
    
    override func execute(with builder: RequestBuilder<ResponseType>, completion: @escaping (Result<ResultType>) -> Void) {
        let predicate = PredicateBuilder().predicate(typeID: builder.URLString)
        
        let cacheRequest = CacheFetchRequest(resultType: HashtagCacheableAdapter.self,
                                             predicate: predicate,
                                             sortDescriptors: [Cache.createdAtSortDescriptor])
        
        cache?.fetchIncoming(with: cacheRequest) { hashtagAdapters in
            let hashtags = hashtagAdapters.map { $0.hashtag }
            DispatchQueue.main.async {
                completion(.success(hashtags))
            }
        }
        
        builder.execute { [weak self] result, error in
            guard error == nil else {
                self?.errorHandler?.handle(error: error, completion: completion)
                return
            }
            let hashtags = result?.body ?? []
            self?.cache?.deleteIncoming(with: predicate)
            let hashtagAdapters = hashtags.map { HashtagCacheableAdapter(handle: UUID().uuidString, hashtag: $0) }
            hashtagAdapters.forEach { self?.cache?.cacheIncoming($0, for: builder.URLString) }
            DispatchQueue.main.async {
                completion(.success(hashtags))
            }
        }
    }
}
