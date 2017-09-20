//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CreateCommentOperationTests: XCTestCase {
    
    func testThatItUsesCorrectServiceMethod() {
        // given
        let comment = Comment(commentHandle: UUID().uuidString)
        comment.topicHandle = UUID().uuidString
        let command = CreateCommentCommand(comment: comment)
        
        let service = MockCommentsService()
        service.postCommentReturnResponse = PostCommentResponse()
        
        let sut = CreateCommentOperation(command: command, commentsService: service)
        
        // when
        let queue = OperationQueue()
        queue.addOperation(sut)
        queue.waitUntilAllOperationsAreFinished()
        
        // then
        XCTAssertTrue(service.postCommentTopicHandleRequestPhotoResultHandlerFailureCalled)
        let args = service.postCommentTopicHandleRequestPhotoResultHandlerFailureReceivedArguments
        XCTAssertEqual(args?.topicHandle, command.comment.topicHandle)
    }
}
