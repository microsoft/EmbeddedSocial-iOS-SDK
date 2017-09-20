//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class CreateCommentOperation: OutgoingCommandOperation {
    let command: CommentCommand
    private let commentsService: CommentServiceProtocol
    
    init(command: CommentCommand, commentsService: CommentServiceProtocol) {
        self.command = command
        self.commentsService = commentsService
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
                
        commentsService.postComment(topicHandle: command.comment.topicHandle,
                                    request: PostCommentRequest(comment: command.comment),
                                    photo: command.comment.mediaPhoto,
                                    resultHandler: { [weak self] _ in self?.completeOperation() },
                                    failure: { [weak self] error in self?.completeOperation(with: error) })
    }
}
