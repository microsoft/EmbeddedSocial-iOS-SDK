//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol CommentsProcessorType {
    func proccess(_ fetchResult: inout CommentFetchResult)
}

class CommentsProcessor: CommentsProcessorType {
    
    let cache: CacheType
    
    required init(cache: CacheType) {
        self.cache = cache
    }
    
    func proccess(_ fetchResult: inout CommentFetchResult) {
        let commands = fetchCreateDeleteCommentCommands() + fetchCommentActionCommands()
        fetchCreateDeleteCommentCommands().filter( { $0.self is RemoveCommentCommand } ) .forEach { (commands) in
            fetchResult.comments = fetchResult.comments.filter({ $0.commentHandle != commands.comment.commentHandle })
        }
        
        fetchResult.comments = fetchResult.comments.map({ (comment) -> Comment in
            var comment = comment
            let commandsToApply = commands.filter { $0.comment.commentHandle == comment.commentHandle }
            for command in commandsToApply {
                command.apply(to: &comment)
            }
            return comment
        })
        
    }
    
    
    private func fetchCommentActionCommands() -> [CommentCommand] {
        let request = CacheFetchRequest(resultType: OutgoingCommand.self,
                                        predicate: PredicateBuilder().commentActionCommands(),
                                        sortDescriptors: [Cache.createdAtSortDescriptor])
        
        return cache.fetchOutgoing(with: request) as? [CommentCommand] ?? []
    }
    
    private func fetchCreateDeleteCommentCommands() -> [CommentCommand] {
        let request = CacheFetchRequest(resultType: OutgoingCommand.self,
                                        predicate: PredicateBuilder.createDeleteCommentCommands(),
                                        sortDescriptors: [Cache.createdAtSortDescriptor])
        
        return cache.fetchOutgoing(with: request) as? [CommentCommand] ?? []
    }
}
