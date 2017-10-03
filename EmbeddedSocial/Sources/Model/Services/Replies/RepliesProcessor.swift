//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//


import Foundation

protocol RepliesProcessorType {
    func proccess(_ fetchResult: inout RepliesFetchResult)
}

class RepliesProcessor: RepliesProcessorType {
    
    let cache: CacheType
    
    required init(cache: CacheType) {
        self.cache = cache
    }
    
    func proccess(_ fetchResult: inout RepliesFetchResult) {
        let commands = fetchCreateDeleteReplyCommands() + fetchReplyActionCommands()
        fetchCreateDeleteReplyCommands().filter( { $0.self is RemoveReplyCommand } ) .forEach { (commands) in
            fetchResult.replies = fetchResult.replies.filter({ $0.replyHandle != commands.reply.replyHandle })
        }
        
        fetchResult.replies = fetchResult.replies.map({ (reply) -> Reply in
            var reply = reply
            let commandsToApply = commands.filter { $0.reply.replyHandle == reply.commentHandle }
            for command in commandsToApply {
                command.apply(to: &reply)
            }
            return reply
        })
        
    }
    
    private func fetchReplyActionCommands() -> [ReplyCommand] {
        let request = CacheFetchRequest(resultType: OutgoingCommand.self,
                                        predicate: PredicateBuilder().replyActionCommands(),
                                        sortDescriptors: [Cache.createdAtSortDescriptor])
        
        return cache.fetchOutgoing(with: request) as? [ReplyCommand] ?? []
    }
    
    private func fetchCreateDeleteReplyCommands() -> [ReplyCommand] {
        let request = CacheFetchRequest(resultType: OutgoingCommand.self,
                                        predicate: PredicateBuilder().createDeleteReplyCommands(),
                                        sortDescriptors: [Cache.createdAtSortDescriptor])
        
        return cache.fetchOutgoing(with: request) as? [ReplyCommand] ?? []
    }
}
