//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class UnpinTopicOperationTests: XCTestCase {
    
    func testThatItUsesCorrectServiceMethod() {
        // given
        let topic = Post.mock(seed: 0)
        let command = TopicCommand(topic: topic)
        let service = MockLikesService()
        let sut = UnpinTopicOperation(command: command, likesService: service)
        
        // when
        let queue = OperationQueue()
        queue.addOperation(sut)
        queue.waitUntilAllOperationsAreFinished()
        
        // then
        XCTAssertTrue(service.deletePinPostHandleCompletionCalled)
        XCTAssertEqual(service.deletePinPostHandleCompletionReceivedArguments?.postHandle, command.topic.topicHandle)
    }
}
