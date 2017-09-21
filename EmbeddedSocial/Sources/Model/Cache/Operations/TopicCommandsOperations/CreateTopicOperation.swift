//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class CreateTopicOperation: OutgoingCommandOperation {
    
    let command: TopicCommand
    private let topicsService: PostServiceProtocol
    private let predicateBuilder: OutgoingCommandsPredicateBuilder.Type
    private let handleUpdater: RelatedHandleUpdater
    
    init(command: TopicCommand,
         topicsService: PostServiceProtocol,
         predicateBuilder: OutgoingCommandsPredicateBuilder.Type = PredicateBuilder.self,
         handleUpdater: RelatedHandleUpdater = OutgoingCommandsRelatedHandleUpdater()) {
        
        self.command = command
        self.topicsService = topicsService
        self.predicateBuilder = predicateBuilder
        self.handleUpdater = handleUpdater
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        let oldHandle = command.topic.topicHandle
        topicsService.postTopic(
            command.topic,
            success: { [weak self] topic in self?.updateRelatedCommandsHandle(from: oldHandle, to: topic.topicHandle) },
            failure: { [weak self] error in self?.completeOperation(with: error) }
        )
    }
    
    private func updateRelatedCommandsHandle(from oldHandle: String?, to newHandle: String) {
        guard let oldHandle = oldHandle else {
            return
        }
        let predicate = predicateBuilder.commandsWithRelatedHandle(oldHandle, ignoredTypeID: CreateTopicCommand.typeIdentifier)
        handleUpdater.updateRelatedHandle(from: oldHandle, to: newHandle, predicate: predicate)
        completeOperation()
    }
}
