//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class RemoveTopicOperationTests: XCTestCase {
    
    func testExecution() {
        let topic = Post.mock()
        let command = TopicCommand(topic: topic)
        let service = PostServiceMock()
        let cleanupStrategy = MockCacheCleanupStrategy()
        let op = RemoveTopicOperation(command: command, topicsService: service, cleanupStrategy: cleanupStrategy)
        
        service.deletePostPostCompletionReturnValue = .success()
        
        let queue = OperationQueue()
        queue.addOperation(op)
        queue.waitUntilAllOperationsAreFinished()
        
        expect(service.deletePostPostCompletionCalled).to(beTrue())
        expect(service.deletePostPostCompletionReceivedPost).to(equal(topic.topicHandle))
        expect(cleanupStrategy.cleanupRelatedCommandsWithTopicCommandCalled).to(beTrue())
        expect(cleanupStrategy.cleanupRelatedCommandsWithTopicCommandReceivedCommand?.topic).to(equal(topic))
    }
    
    func testExecutionWhenServiceFails() {
        let topic = Post.mock()
        let command = TopicCommand(topic: topic)
        let service = PostServiceMock()
        let cleanupStrategy = MockCacheCleanupStrategy()
        let op = RemoveTopicOperation(command: command, topicsService: service, cleanupStrategy: cleanupStrategy)
        
        service.deletePostPostCompletionReturnValue = .failure(APIError.unknown)
        
        let queue = OperationQueue()
        queue.addOperation(op)
        queue.waitUntilAllOperationsAreFinished()
        
        expect(service.deletePostPostCompletionCalled).to(beTrue())
        expect(service.deletePostPostCompletionReceivedPost).to(equal(topic.topicHandle))
        expect(cleanupStrategy.cleanupRelatedCommandsWithTopicCommandCalled).to(beFalse())
        expect(op.error).to(matchError(APIError.unknown))
    }
}
