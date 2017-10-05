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
    
    func getTrending(completion: @escaping (Result<[Hashtag]>) -> Void) {
        HashtagsAPI.hashtagsGetTrendingHashtags(authorization: authorization) { hashtags, error in
            if let hashtags = hashtags {
                completion(.success(hashtags))
            } else {
                self.errorHandler.handle(error: error, completion: completion)
            }
        }
    }
}
