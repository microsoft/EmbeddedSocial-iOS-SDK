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
    
    private let postProcessor: FeedCachePostProcessor
    
    init(processor: FeedCachePostProcessor) {
        self.postProcessor = processor
    }
    
    func parse(_ response: FeedResponseTopicView?, isCached: Bool, into result: inout FeedFetchResult) {
        guard let response = response else {
            return
        }
        
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
    private let cache: CacheType!
    
    init(cache: CacheType) {
        self.cache = cache
    }
    
    func process(_ feed: inout FeedFetchResult) {
        let commands = fetchTopicCommands()
        
        feed.posts = feed.posts.map { topic -> Post in
            var topic = topic
            let commandsToApply = commands.filter { $0.topic.topicHandle == topic.topicHandle }
            for command in commandsToApply {
                command.apply(to: &topic)
            }
            return topic
        }
    }
    
    private func fetchTopicCommands() -> [TopicCommand] {
        let request = CacheFetchRequest(resultType: OutgoingCommand.self,
                                        predicate: PredicateBuilder.allTopicCommandsPredicate(),
                                        sortDescriptors: [Cache.createdAtSortDescriptor])
        
        return cache.fetchOutgoing(with: request) as? [TopicCommand] ?? []
    }
}
