//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class RemoveCommentOperation: OutgoingCommandOperation {
    let commentService: CommentServiceProtocol
    let command: CommentCommand
    
    required init(command: CommentCommand, commentService: CommentServiceProtocol) {
        self.command = command
        self.commentService = commentService
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        commentService.delete(comment: command.comment) { (result) in
            self.completeOperation(with: result.error)
        }
    }
}
