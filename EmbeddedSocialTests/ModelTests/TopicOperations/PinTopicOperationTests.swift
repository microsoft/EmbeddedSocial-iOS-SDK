//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class PinTopicOperationTests: XCTestCase {
    
    func testThatItUsesCorrectServiceMethod() {
        // given
        let topic = Post(topicHandle: UUID().uuidString)
        let command = TopicCommand(topic: topic)
        let service = MockLikesService()
        let sut = PinTopicOperation(command: command, likesService: service)
        
        // when
        let queue = OperationQueue()
        queue.addOperation(sut)
        queue.waitUntilAllOperationsAreFinished()
        
        // then
        XCTAssertTrue(service.postPinPostHandleCompletionCalled)
        XCTAssertEqual(service.postPinPostHandleCompletionReceivedArguments?.postHandle, command.topic.topicHandle)
    }
}
