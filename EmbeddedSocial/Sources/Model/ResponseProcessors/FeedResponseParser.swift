//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol FeedResponseParserProtocol: class {
    func parse(_ response: FeedResponseTopicView?, isCached: Bool, into result: inout FeedFetchResult)
}

protocol FeedResponsePostProcessorType {
    func process(_ feed: inout FeedFetchResult)
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

class FeedResponsePostProcessor: FeedResponsePostProcessorType {
    private let cache: CacheType!
    let predicateBuilder: TopicServicePredicateBuilder
    
    var fetchTopicsPredicate: NSPredicate {
        return predicateBuilder.allTopicCommands()
    }
    
    init(cache: CacheType, predicateBuilder: TopicServicePredicateBuilder = PredicateBuilder()) {
        self.cache = cache
        self.predicateBuilder = predicateBuilder
    }
    
    func process(_ feed: inout FeedFetchResult) {
        let commands = fetchTopicActionCommands()
        for command in commands {
            command.apply(to: &feed)
        }
    }
    
    private func fetchTopicActionCommands() -> [TopicCommand] {
        let request = CacheFetchRequest(resultType: OutgoingCommand.self,
                                        predicate: fetchTopicsPredicate,
                                        sortDescriptors: [Cache.createdAtSortDescriptor])
        
        return cache.fetchOutgoing(with: request) as? [TopicCommand] ?? []
    }
}

final class OtherUserFeedResponsePostProcessor: FeedResponsePostProcessor {
    
    override var fetchTopicsPredicate: NSPredicate {
        return predicateBuilder.allTopicActionCommands()
    }
}
