//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol FeedCacheAdapterProtocol: class {
    func cached(by cacheKey: String) -> FeedResponseTopicView?
}

class FeedCacheAdapter: FeedCacheAdapterProtocol {
    
    let cache: CacheType!
    
    init(cache: CacheType) {
        self.cache = cache
    }
    
    func cached(by cacheKey: String) -> FeedResponseTopicView? {
        return cache.firstIncoming(ofType: FeedResponseTopicView.self, typeID: cacheKey)
    }
}


protocol FeedResponseParserProtocol: class {
    func parse(_ response: FeedResponseTopicView?, isCached: Bool, into result: inout PostFetchResult)
}

class FeedResponseParser: FeedResponseParserProtocol {
    
    var postProcessor: FeedCachePostProcessor!
    
    init(processor: FeedCachePostProcessor) {
        self.postProcessor = processor
    }
    
    func parse(_ response: FeedResponseTopicView?, isCached: Bool, into result: inout PostFetchResult) {
        
        guard let response = response else { return }
        
        if let data = response.data {
            result.posts = data.map(Post.init)
        }
        result.cursor = response.cursor
        
        if isCached {
            postProcessor.process(&result)
        }
    }
}

class FeedCachePostProcessor {
    
    let cacheAdapter: FeedCacheActionsAdapter!
    
    init(cacheAdapter: FeedCacheActionsAdapter) {
        self.cacheAdapter = cacheAdapter
    }
    
    private func apply(actions: [FeedActionRequest], to post: inout Post) {
        
        actions.forEach { action in
            
            switch action.actionType {
            case .like:
                post.liked = action.actionMethod.isIncreasing()
                post.totalLikes += action.actionMethod.isIncreasing() ? 1 : -1
            case .pin:
                post.pinned = (action.actionMethod == .delete) ? false : true
            }
        }
    }
    
    func process(_ feed: inout PostFetchResult) {
        
        let cachedActions = cacheAdapter.getAllCachedActions()
        
        for index in 0..<feed.posts.count {
            
            var post = feed.posts[index]
            
            let matching = cachedActions.filter({ (action) -> Bool in
                return action.handle == post.topicHandle
            })
            
            guard matching.count > 0 else { continue }
            
            apply(actions: matching, to: &post)
            
            feed.posts[index] = post
        }
    }
}
