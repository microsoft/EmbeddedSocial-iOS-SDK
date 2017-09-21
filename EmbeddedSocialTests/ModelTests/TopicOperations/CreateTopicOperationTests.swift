//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CreateTopicOperationTests: XCTestCase {
    
    func testThatItUsesCorrectServiceMethod() {
        // given
        let topic = Post(topicHandle: UUID().uuidString)
        let command = CreateTopicCommand(topic: topic)
        
        let service = PostServiceMock()
        service.postTopicReturnTopic = topic
        
        let sut = CreateTopicOperation(command: command, topicsService: service)
        
        // when
        let queue = OperationQueue()
        queue.addOperation(sut)
        queue.waitUntilAllOperationsAreFinished()
        
        // then
        XCTAssertTrue(service.postTopicCalled)
    }
}
