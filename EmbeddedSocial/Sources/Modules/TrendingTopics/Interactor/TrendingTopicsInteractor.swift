//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class TrendingTopicsInteractor: TrendingTopicsInteractorInput {
    
    private let hashtagsService: HashtagsServiceType
    private let networkTracker: NetworkStatusMulticast
    
    init(hashtagsService: HashtagsServiceType, networkTracker: NetworkStatusMulticast = SocialPlus.shared.networkTracker) {
        self.hashtagsService = hashtagsService
        self.networkTracker = networkTracker
    }
    
    func getTrendingHashtags(completion: @escaping (Result<[Hashtag]>) -> Void) {
        hashtagsService.getTrending { result in
            completion(result.map { $0.items })
        }
    }
    
    func reloadTrendingHashtags(completion: @escaping (Result<[Hashtag]>) -> Void) {
        let skipCache = networkTracker.isReachable
        hashtagsService.getTrending { response in
            if skipCache && response.value?.isFromCache == true {
                return
            }
            completion(response.map { $0.items })
        }
    }
}
