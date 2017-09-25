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
    func parse(_ response: FeedResponseTopicView?, isCached: Bool, into result: inout FeedFetchResult)
}

class FeedResponseParser: FeedResponseParserProtocol {
    
    private let postProcessor: FeedResponsePostProcessorType
    
    init(processor: FeedResponsePostProcessorType) {
        self.postProcessor = processor
    }
    
    func parse(_ response: FeedResponseTopicView?, isCached: Bool, into result: inout FeedFetchResult) {
        guard let response = response else {
            return
        }
        
        if let data = response.data {
            result.posts += data.map(Post.init)
        }
        
        result.cursor = response.cursor
        
        if isCached {
            postProcessor.process(&result)
        }
    }
}

protocol FeedResponsePostProcessorType {
    func process(_ feed: inout FeedFetchResult)
}

class FeedResponsePostProcessor: FeedResponsePostProcessorType {
    private let cache: CacheType!
    
    var fetchTopicsPredicate: NSPredicate {
        return PredicateBuilder.allTopicActionCommands()
    }
    
    init(cache: CacheType) {
        self.cache = cache
    }
    
    func process(_ feed: inout FeedFetchResult) {
        let commands = fetchTopicActionCommands()
        for command in commands {
            command.apply(to: &feed)
        }
    }
    
    private func fetchTopicActionCommands() -> [TopicCommand] {
        let request = CacheFetchRequest(resultType: OutgoingCommand.self,
                                        predicate: PredicateBuilder.allTopicActionCommands(),
                                        sortDescriptors: [Cache.createdAtSortDescriptor])
        
        return cache.fetchOutgoing(with: request) as? [TopicCommand] ?? []
    }
}

final class OtherUserFeedResponsePostProcessor: FeedResponsePostProcessor {
    
    override var fetchTopicsPredicate: NSPredicate {
        return PredicateBuilder.allTopicActionCommands()
    }
}




















