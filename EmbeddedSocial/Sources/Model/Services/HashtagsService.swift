//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

typealias Hashtag = String

protocol HashtagsServiceType {
    func getTrending(completion: @escaping (Result<PaginatedResponse<Hashtag>>) -> Void)
}

final class HashtagsService: BaseService, HashtagsServiceType {
    
    private var requestExecutor: HashtagsRequestExecutor!

    init(ExecutorProvider: CacheRequestExecutorProviderType.Type = CacheRequestExecutorProvider.self) {
        super.init()
        requestExecutor = ExecutorProvider.makeHashtagsExecutor(for: self)
    }
    
    func getTrending(completion: @escaping (Result<PaginatedResponse<Hashtag>>) -> Void) {
        let builder = HashtagsAPI.hashtagsGetTrendingHashtagsWithRequestBuilder(authorization: authorization)
        requestExecutor.execute(with: builder, completion: completion)
    }
}
