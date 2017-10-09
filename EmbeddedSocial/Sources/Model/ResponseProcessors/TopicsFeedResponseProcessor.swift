//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class TopicsFeedResponseProcessor: ResponseProcessor<FeedResponseTopicView, FeedFetchResult> {
    
    private let queue: OperationQueue = {
        let q = OperationQueue()
        q.name = "TopicsFeedResponseProcessor-queue"
        q.qualityOfService = .userInitiated
        return q
    }()
    
    let cache: CacheType
    let operationsBuilder: OutgoingCommandOperationsBuilderType
    let predicateBuilder: TopicServicePredicateBuilder
    
    var fetchTopicsPredicate: NSPredicate {
        return predicateBuilder.allTopicCommands()
    }
    
    init(cache: CacheType,
         operationsBuilder: OutgoingCommandOperationsBuilderType = OutgoingCommandOperationsBuilder(),
         predicateBuilder: TopicServicePredicateBuilder = PredicateBuilder()) {
        
        self.cache = cache
        self.operationsBuilder = operationsBuilder
        self.predicateBuilder = predicateBuilder
    }
    
    override func process(_ response: FeedResponseTopicView?,
                          isFromCache: Bool,
                          completion: @escaping (Result<FeedFetchResult>) -> Void) {
        
        let feed = FeedFetchResult(response: response)
        
        guard isFromCache else {
            completion(.success(feed))
            return
        }
        
        applyTopicFeedCommands(to: feed) { processedFeed in
            DispatchQueue.main.async {
                completion(.success(processedFeed))
            }
        }
    }
    
    private func applyTopicFeedCommands(to feed: FeedFetchResult, completion: @escaping (FeedFetchResult) -> Void) {
        let fetchCommands = operationsBuilder.fetchCommandsOperation(cache: cache, predicate: fetchTopicsPredicate)
        
        fetchCommands.completionBlock = { [weak self] in
            guard let strongSelf = self, !fetchCommands.isCancelled else {
                completion(feed)
                return
            }
            
            strongSelf.queue.addOperation {
                let commands = fetchCommands.commands as? [TopicCommand] ?? []
                let list = strongSelf.apply(commands: commands, to: feed)
                completion(list)
            }
        }
        
        queue.addOperation(fetchCommands)
    }
    
    func apply(commands: [TopicCommand], to feed: FeedFetchResult) -> FeedFetchResult {
        var feed = feed
        
        for command in commands {
            command.apply(to: &feed)
        }
        
        return feed
    }
}
