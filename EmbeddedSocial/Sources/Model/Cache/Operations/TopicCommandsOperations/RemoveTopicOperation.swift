//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class RemoveTopicOperation: OutgoingCommandOperation {
    
    let command: TopicCommand
    private let topicsService: PostServiceProtocol
    private let predicateBuilder: OutgoingCommandsPredicateBuilder
    private let cache: CacheType
    private let cleanupStrategy: CacheCleanupStrategy
    
    init(command: TopicCommand,
         topicsService: PostServiceProtocol,
         cache: CacheType = SocialPlus.shared.cache,
         predicateBuilder: OutgoingCommandsPredicateBuilder = PredicateBuilder()) {
        
        self.command = command
        self.topicsService = topicsService
        self.cache = cache
        self.predicateBuilder = predicateBuilder
        self.cleanupStrategy = CacheCleanupStrategyImpl(cache: cache, predicateBuilder: predicateBuilder)
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        topicsService.deletePost(post: command.topic.topicHandle) { [weak self, command] result in
            guard result.isSuccess else {
                self?.completeOperation(with: result.error)
                return
            }
//            Dispatch.async
            self?.cleanupStrategy.cleanupRelatedCommands(command)
            self?.completeOperation()
        }
    }
}
