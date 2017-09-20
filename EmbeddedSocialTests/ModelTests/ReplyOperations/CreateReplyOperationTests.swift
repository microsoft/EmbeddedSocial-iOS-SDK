//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CreateReplyOperationTests: XCTestCase {
    
    func testThatItUsesCorrectServiceMethod() {
        // given
        let reply = Reply(replyHandle: UUID().uuidString)
        reply.commentHandle = UUID().uuidString
        let command = CreateReplyCommand(reply: reply)
        
        let service = MockRepliesService()
        service.postReplyReturnResponse = PostReplyResponse()
        
        let sut = CreateReplyOperation(command: command, repliesService: service)
        
        // when
        let queue = OperationQueue()
        queue.addOperation(sut)
        queue.waitUntilAllOperationsAreFinished()
        
        // then
        XCTAssertTrue(service.postReplyCalled)
        XCTAssertEqual(service.postReplyReceivedArguments?.commentHandle, command.reply.commentHandle)
    }
}
