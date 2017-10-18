//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class RemoveTopicOperation: TopicCommandOperation {
    
    private let topicsService: PostServiceProtocol
    private let cleanupStrategy: CacheCleanupStrategy
    
    init(command: TopicCommand, topicsService: PostServiceProtocol, cleanupStrategy: CacheCleanupStrategy) {
        self.topicsService = topicsService
        self.cleanupStrategy = cleanupStrategy
        super.init(command: command)
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        topicsService.deletePost(post: command.topic.topicHandle) { [weak self] result in
            if result.isSuccess {
                self?.cleanupAndComplete()
            } else {
                self?.completeOperation(with: result.error)
            }
        }
    }
    
    private func cleanupAndComplete() {
        cleanupStrategy.cleanupRelatedCommands(command)
        completeOperation()
    }
}
