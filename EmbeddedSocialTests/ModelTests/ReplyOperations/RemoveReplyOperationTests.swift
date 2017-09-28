//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class RemoveReplyOperationTests: XCTestCase {
    
    func testThatItUsesCorrectServiceMethod() {
        // given
        let reply = Reply(replyHandle: UUID().uuidString)
        let command = ReplyCommand(reply: reply)
        let service = MockRepliesService()
        let sut = RemoveReplyOperation(command: command, repliesService: service)
        
        // when
        let queue = OperationQueue()
        queue.addOperation(sut)
        queue.waitUntilAllOperationsAreFinished()
        
        // then
        XCTAssertTrue(service.deleteReplyCalled)
    }
    
}
