//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class CreateReplyOperation: OutgoingCommandOperation {
    let command: ReplyCommand
    private let repliesService: RepliesServiceProtcol
    private let predicateBuilder: OutgoingCommandsPredicateBuilder
    private let handleUpdater: RelatedHandleUpdater
    
    init(command: ReplyCommand,
         repliesService: RepliesServiceProtcol,
         predicateBuilder: OutgoingCommandsPredicateBuilder = PredicateBuilder(),
         handleUpdater: RelatedHandleUpdater = OutgoingCommandsRelatedHandleUpdater()) {
        
        self.command = command
        self.repliesService = repliesService
        self.predicateBuilder = predicateBuilder
        self.handleUpdater = handleUpdater
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        let oldHandle = command.reply.replyHandle
        repliesService.postReply(
            reply: command.reply,
            success: { [weak self] reply in self?.updateRelatedCommandsHandle(from: oldHandle, to: reply.replyHandle) },
            failure: { [weak self] error in self?.completeOperation(with: error) })
    }
    
    private func updateRelatedCommandsHandle(from oldHandle: String?, to newHandle: String?) {
        guard let oldHandle = oldHandle, let newHandle = newHandle else {
            completeOperation()
            return
        }
        
        let predicate = predicateBuilder.commandsWithRelatedHandle(oldHandle, ignoredTypeID: CreateReplyCommand.typeIdentifier)
        handleUpdater.updateRelatedHandle(from: oldHandle, to: newHandle, predicate: predicate)
//        handleUpdat
        completeOperation()
    }
}
