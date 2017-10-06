//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

typealias Hashtag = String

protocol HashtagsServiceType {
    func getTrending(completion: @escaping (Result<[Hashtag]>) -> Void)
}

final class HashtagsService: BaseService, HashtagsServiceType {
    
    private var requestExecutor: HashtagsRequestExecutor!

    init(executorProvider: CacheRequestExecutorProviderType.Type = CacheRequestExecutorProvider.self) {
        super.init()
        requestExecutor = executorProvider.makeHashtagsExecutor(for: self)
    }
    
    func getTrending(completion: @escaping (Result<[Hashtag]>) -> Void) {
        let builder = HashtagsAPI.hashtagsGetTrendingHashtagsWithRequestBuilder(authorization: authorization)
        requestExecutor.execute(with: builder, completion: completion)
        
//        HashtagsAPI.hashtagsGetTrendingHashtags(authorization: authorization) { hashtags, error in
//            if let hashtags = hashtags {
//                completion(.success(hashtags))
//            } else {
//                self.errorHandler.handle(error: error, completion: completion)
//            }
//        }
    }
}
