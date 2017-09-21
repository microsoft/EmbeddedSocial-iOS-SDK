//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class CreateCommentOperation: OutgoingCommandOperation {
    let command: CommentCommand
    private let commentsService: CommentServiceProtocol
    private let predicateBuilder: OutgoingCommandsPredicateBuilder.Type
    private let handleUpdater: RelatedHandleUpdater
    
    init(command: CommentCommand,
         commentsService: CommentServiceProtocol,
         predicateBuilder: OutgoingCommandsPredicateBuilder.Type = PredicateBuilder.self,
         handleUpdater: RelatedHandleUpdater = OutgoingCommandsRelatedHandleUpdater()) {
        
        self.command = command
        self.commentsService = commentsService
        self.predicateBuilder = predicateBuilder
        self.handleUpdater = handleUpdater
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        let oldHandle = command.comment.commentHandle
        
        commentsService.postComment(
            topicHandle: command.comment.topicHandle,
            request: PostCommentRequest(comment: command.comment),
            photo: command.comment.mediaPhoto,
            resultHandler: { [weak self] comment in self?.updateRelatedCommandsHandle(from: oldHandle, to: comment.commentHandle) },
            failure: { [weak self] error in self?.completeOperation(with: error) })
    }
    
    private func updateRelatedCommandsHandle(from oldHandle: String?, to newHandle: String?) {
        guard let oldHandle = oldHandle, let newHandle = newHandle else {
            return
        }
        let predicate = predicateBuilder.commandsWithRelatedHandle(oldHandle, ignoredTypeID: CreateCommentCommand.typeIdentifier)
        handleUpdater.updateRelatedHandle(from: oldHandle, to: newHandle, predicate: predicate)
        completeOperation()
    }
}
