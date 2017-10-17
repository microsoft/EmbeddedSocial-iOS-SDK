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
    
    init(command: TopicCommand,
         topicsService: PostServiceProtocol,
         cache: CacheType = SocialPlus.shared.cache,
         predicateBuilder: OutgoingCommandsPredicateBuilder = PredicateBuilder()) {
        
        self.command = command
        self.topicsService = topicsService
        self.cache = cache
        self.predicateBuilder = predicateBuilder
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        let predicate = predicateBuilder.commandsWithRelatedHandle(command.topic.topicHandle, ignoredTypeID: command.typeIdentifier)
        topicsService.deletePost(post: command.topic.topicHandle) { [weak self] result in
            guard result.isSuccess else {
                self?.completeOperation(with: result.error)
                return
            }
            
            self?.cache.deleteOutgoing(with: predicate)
            self?.completeOperation()
        }
    }
}
