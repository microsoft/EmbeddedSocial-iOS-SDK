//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class RemoveCommentOperationTests: XCTestCase {
    
    func testThatItUsesCorrectServiceMethod() {
        // given
        let comment = Comment(commentHandle: UUID().uuidString)
        let command = CommentCommand(comment: comment)
        let service = MockCommentsService()
        service.deleteCommentCompletionReceivedCommentHandle = comment.commentHandle
        let sut = RemoveCommentOperation(command: command, commentService: service)
        
        // when
        let queue = OperationQueue()
        queue.addOperation(sut)
        queue.waitUntilAllOperationsAreFinished()
        
        // then
        XCTAssertTrue(service.deleteCommentCompletionCalled)
        XCTAssertEqual(service.deleteCommentCompletionReceivedCommentHandle, comment.commentHandle)
    }
}
