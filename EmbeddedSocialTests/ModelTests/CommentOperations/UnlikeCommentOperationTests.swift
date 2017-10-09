//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class UnlikeCommentOperationTests: XCTestCase {
    
    func testThatItUsesCorrectServiceMethod() {
        // given
        let comment = Comment(commentHandle: UUID().uuidString)
        let command = CommentCommand(comment: comment)
        let service = MockLikesService()
        service.unlikeCommentCommentHandleCompletionReturnValue = (command.comment.commentHandle, nil)
        let sut = UnlikeCommentOperation(command: command, likesService: service)
        
        // when
        let queue = OperationQueue()
        queue.addOperation(sut)
        queue.waitUntilAllOperationsAreFinished()
        
        // then
        XCTAssertTrue(service.unlikeCommentCommentHandleCompletionCalled)
        XCTAssertEqual(service.unlikeCommentCommentHandleCompletionReceivedArguments?.commentHandle, command.comment.commentHandle)
    }
}
