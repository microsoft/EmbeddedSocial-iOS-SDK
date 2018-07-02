//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class CreateTopicOperation: TopicCommandOperation {
    
    private let topicsService: PostServiceProtocol
    private let predicateBuilder: OutgoingCommandsPredicateBuilder
    private let handleUpdater: RelatedHandleUpdater
    
    init(command: TopicCommand,
         topicsService: PostServiceProtocol,
         predicateBuilder: OutgoingCommandsPredicateBuilder = PredicateBuilder(),
         handleUpdater: RelatedHandleUpdater = OutgoingCommandsRelatedHandleUpdater()) {
        
        self.topicsService = topicsService
        self.predicateBuilder = predicateBuilder
        self.handleUpdater = handleUpdater
        
        super.init(command: command)
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        let oldHandle = command.topic.topicHandle
        topicsService.postTopic(
            command.topic, photo: command.topic.photo,
            success: { [weak self] topic in self?.updateRelatedCommandsHandle(from: oldHandle, to: topic.topicHandle) },
            failure: { [weak self] error in self?.completeOperation(with: error) }
        )
    }
    
    private func updateRelatedCommandsHandle(from oldHandle: String?, to newHandle: String) {
        guard let oldHandle = oldHandle else {
            completeOperation()
            return
        }
        let predicate = predicateBuilder.commandsWithRelatedHandle(oldHandle, ignoredTypeID: CreateTopicCommand.typeIdentifier)
        handleUpdater.updateRelatedHandle(from: oldHandle, to: newHandle, predicate: predicate)
        completeOperation()
    }
}
