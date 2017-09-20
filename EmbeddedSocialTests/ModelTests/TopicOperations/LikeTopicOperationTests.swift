//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class LikeTopicOperationTests: XCTestCase {
    
    func testThatItUsesCorrectServiceMethod() {
        // given
        let topic = Post(topicHandle: UUID().uuidString)
        let command = TopicCommand(topic: topic)
        let service = MockLikesService()
        let sut = LikeTopicOperation(command: command, likesService: service)
        
        // when
        let queue = OperationQueue()
        queue.addOperation(sut)
        queue.waitUntilAllOperationsAreFinished()
        
        // then
        XCTAssertTrue(service.postLikePostHandleCompletionCalled)
        XCTAssertEqual(service.postLikePostHandleCompletionReceivedArguments?.postHandle, command.topic.topicHandle)
    }
}
