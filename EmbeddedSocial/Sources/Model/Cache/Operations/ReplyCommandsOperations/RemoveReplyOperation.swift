//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class RemoveReplyOperation: ReplyCommandOperation {
    private let repliesService: RepliesServiceProtcol
    private let cleanupStrategy: CacheCleanupStrategy
    
    required init(command: ReplyCommand, repliesService: RepliesServiceProtcol, cleanupStrategy: CacheCleanupStrategy) {
        self.repliesService = repliesService
        self.cleanupStrategy = cleanupStrategy
        super.init(command: command)
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        repliesService.delete(reply: command.reply) { [weak self, command] result in
            self?.cleanupStrategy.cleanupRelatedCommands(command)
            self?.completeOperation(with: result.error)
        }
    }
}
