//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class LikeReplyOperationTests: XCTestCase {
    
    func testThatItUsesCorrectServiceMethod() {
        // given
        let reply = Reply(replyHandle: UUID().uuidString)
        let command = ReplyCommand(reply: reply)
        let service = MockLikesService()
        service.likeReplyReplyHandleCompletionReturnValue = (command.reply.replyHandle, nil)
        let sut = LikeReplyOperation(command: command, likesService: service)
        
        // when
        let queue = OperationQueue()
        queue.addOperation(sut)
        queue.waitUntilAllOperationsAreFinished()
        
        // then
        XCTAssertTrue(service.likeReplyReplyHandleCompletionCalled)
        XCTAssertEqual(service.likeReplyReplyHandleCompletionReceivedArguments?.replyHandle, command.reply.replyHandle)
    }
}
