//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class LikeCommentOperationTests: XCTestCase {
    
    func testThatItUsesCorrectServiceMethod() {
        // given
        let command = CommentCommand(commentHandle: UUID().uuidString)
        let service = MockLikesService()
        service.likeCommentCommentHandleCompletionReturnValue = (command.commentHandle, nil)
        let sut = LikeCommentOperation(command: command, likesService: service)
        
        // when
        let queue = OperationQueue()
        queue.addOperation(sut)
        queue.waitUntilAllOperationsAreFinished()
        
        // then
        XCTAssertTrue(service.likeCommentCommentHandleCompletionCalled)
        XCTAssertEqual(service.likeCommentCommentHandleCompletionReceivedArguments?.commentHandle, command.commentHandle)
    }
}
