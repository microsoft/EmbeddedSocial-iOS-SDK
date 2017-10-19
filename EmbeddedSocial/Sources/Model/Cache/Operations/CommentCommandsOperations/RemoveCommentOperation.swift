//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class RemoveCommentOperation: CommentCommandOperation {
    let commentService: CommentServiceProtocol
    let cleanupStrategy: CacheCleanupStrategy

    required init(command: CommentCommand, commentService: CommentServiceProtocol, cleanupStrategy: CacheCleanupStrategy) {
        self.commentService = commentService
        self.cleanupStrategy = cleanupStrategy
        super.init(command: command)
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        commentService.delete(comment: command.comment) { [weak self, command] result in
            self?.cleanupStrategy.cleanupRelatedCommands(command)
            self?.completeOperation(with: result.error)
        }
    }
}
