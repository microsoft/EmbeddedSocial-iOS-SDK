//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class TrendingTopicsInteractor: TrendingTopicsInteractorInput {
    
    private let hashtagsService: HashtagsServiceType
    
    init(hashtagsService: HashtagsServiceType) {
        self.hashtagsService = hashtagsService
    }
    
    func getTrendingHashtags(completion: @escaping (Result<[Hashtag]>) -> Void) {
        hashtagsService.getTrending(completion: completion)
    }
}
