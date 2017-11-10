//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//


import Foundation

protocol RepliesProcessorType {
    func proccess(_ fetchResult: inout RepliesFetchResult, commentHandle: String)
}

class RepliesProcessor: RepliesProcessorType {
    
    private let cache: CacheType
    private let predicateBuilder = PredicateBuilder()
    private var commands: [ReplyCommand] = []
    
    init(cache: CacheType) {
        self.cache = cache
    }
    
    func proccess(_ feed: inout RepliesFetchResult, commentHandle: String) {
        commands = fetchAllReplyCommands()
        applyCreateDeleteCommands(to: &feed, commentHandle: commentHandle)
        applyReplyActionCommands(to: &feed)
    }
    
    private func fetchAllReplyCommands() -> [ReplyCommand] {
        let request = CacheFetchRequest(
            resultType: OutgoingCommand.self,
            predicate: predicateBuilder.allReplyCommands(),
            sortDescriptors: [Cache.createdAtSortDescriptor]
        )
        
        return cache.fetchOutgoing(with: request) as? [ReplyCommand] ?? []
    }
    
    private func applyCreateDeleteCommands(to feed: inout RepliesFetchResult, commentHandle: String) {
        for command in commands where !command.isActionCommand && command.reply.commentHandle == commentHandle {
            command.apply(to: &feed)
        }
    }
    
    private func applyReplyActionCommands(to feed: inout RepliesFetchResult) {
        for command in commands where command.isActionCommand {
            command.apply(to: &feed)
        }
    }

}
