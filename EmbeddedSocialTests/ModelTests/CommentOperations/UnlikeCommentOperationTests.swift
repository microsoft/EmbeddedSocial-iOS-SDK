//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class UnlikeCommentOperationTests: XCTestCase {
    
    func testThatItUsesCorrectServiceMethod() {
        // given
        let command = CommentCommand(commentHandle: UUID().uuidString)
        let service = MockLikesService()
        service.unlikeCommentCommentHandleCompletionReturnValue = (command.commentHandle, nil)
        let sut = UnlikeCommentOperation(command: command, likesService: service)
        
        // when
        let queue = OperationQueue()
        queue.addOperation(sut)
        queue.waitUntilAllOperationsAreFinished()
        
        // then
        XCTAssertTrue(service.unlikeCommentCommentHandleCompletionCalled)
        XCTAssertEqual(service.unlikeCommentCommentHandleCompletionReceivedArguments?.commentHandle, command.commentHandle)
    }
}
