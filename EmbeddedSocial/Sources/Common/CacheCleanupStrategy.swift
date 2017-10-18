//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol CacheCleanupStrategy {
    func cleanupRelatedCommands(_ command: TopicCommand)
    func cleanupRelatedCommands(_ command: CommentCommand)
    func cleanupRelatedCommands(_ command: ReplyCommand)
}

struct CacheCleanupStrategyImpl: CacheCleanupStrategy {
    private let cache: CacheType
    private let predicateBuilder: OutgoingCommandsPredicateBuilder
    
    init(cache: CacheType, predicateBuilder: OutgoingCommandsPredicateBuilder = PredicateBuilder()) {
        self.cache = cache
        self.predicateBuilder = predicateBuilder
    }
    
    func cleanupRelatedCommands(_ command: TopicCommand) {
        topicComments(command.topic).forEach(cleanupRelatedCommands)
        
        let p = predicateBuilder.predicate(relatedHandle: command.topic.topicHandle)
        cache.deleteOutgoing(with: p)
    }
    
    private func topicComments(_ topic: Post) -> [CreateCommentCommand] {
        let p = predicateBuilder.predicate(typeID: CreateCommentCommand.typeIdentifier, relatedHandle: topic.topicHandle)
        return fetchOutgoingCommands(with: p) as? [CreateCommentCommand] ?? []
    }
    
    func cleanupRelatedCommands(_ command: CommentCommand) {
        commentReplies(command.comment).forEach(cleanupRelatedCommands)
        
        let p = predicateBuilder.predicate(relatedHandle: command.comment.commentHandle)
        cache.deleteOutgoing(with: p)
    }
    
    private func commentReplies(_ comment: Comment) -> [CreateReplyCommand] {
        let p = predicateBuilder.predicate(typeID: CreateReplyCommand.typeIdentifier, relatedHandle: comment.commentHandle)
        return fetchOutgoingCommands(with: p) as? [CreateReplyCommand] ?? []
    }
    
    func cleanupRelatedCommands(_ command: ReplyCommand) {
        let p = predicateBuilder.predicate(relatedHandle: command.reply.replyHandle)
        cache.deleteOutgoing(with: p)
    }
    
    private func fetchOutgoingCommands(with predicate: NSPredicate) -> [OutgoingCommand] {
        let request = CacheFetchRequest(resultType: OutgoingCommand.self,
                                        predicate: predicate,
                                        sortDescriptors: [Cache.createdAtSortDescriptor])
        return cache.fetchOutgoing(with: request)
    }
}
