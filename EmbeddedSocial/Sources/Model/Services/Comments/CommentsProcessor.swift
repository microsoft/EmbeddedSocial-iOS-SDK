//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol CommentsProcessorType {
    func proccess(_ fetchResult: inout CommentFetchResult, topicHandle: String)
}

class CommentsProcessor: CommentsProcessorType {
    
    private let cache: CacheType
    private let predicateBuilder = PredicateBuilder()
    private var commands: [CommentCommand] = []
    
    required init(cache: CacheType) {
        self.cache = cache
    }
    
    func proccess(_ feed: inout CommentFetchResult, topicHandle: String) {
        commands = fetchAllCommentCommands()
        applyCreateDeleteCommands(to: &feed, topicHandle: topicHandle)
        applyCommentActionCommands(to: &feed)
        applyReplyCommands(to: &feed)
    }
    
    private func fetchAllCommentCommands() -> [CommentCommand] {
        let request = CacheFetchRequest(
            resultType: OutgoingCommand.self,
            predicate: predicateBuilder.allCommentCommands(),
            sortDescriptors: [Cache.createdAtSortDescriptor]
        )
        
        return cache.fetchOutgoing(with: request) as? [CommentCommand] ?? []
    }
    
    private func applyCreateDeleteCommands(to feed: inout CommentFetchResult, topicHandle: String) {
        for command in commands where !command.isActionCommand && command.comment.topicHandle == topicHandle {
            command.apply(to: &feed)
        }
    }
    
    private func applyCommentActionCommands(to feed: inout CommentFetchResult) {
        for command in commands where command.isActionCommand {
            command.apply(to: &feed)
        }
    }
    
    private func applyReplyCommands(to feed: inout CommentFetchResult) {
        for case let command in fetchCreateReplyCommands() {
            command.apply(to: &feed)
        }
    }
    
    private func fetchCreateReplyCommands() -> [CreateReplyCommand] {
        let request = CacheFetchRequest(resultType: OutgoingCommand.self,
                                        predicate: PredicateBuilder().createReplyCommands(),
                                        sortDescriptors: [Cache.createdAtSortDescriptor])
        
        return cache.fetchOutgoing(with: request) as? [CreateReplyCommand] ?? []
    }
    
}
