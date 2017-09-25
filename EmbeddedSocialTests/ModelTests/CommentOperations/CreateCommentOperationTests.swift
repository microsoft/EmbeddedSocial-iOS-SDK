//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CreateCommentOperationTests: XCTestCase {
    
    var predicateBuilder: MockOutgoingCommandsPredicateBuilder!
    var handleUpdater: MockRelatedHandleUpdater!
    
    override func setUp() {
        super.setUp()
        predicateBuilder = MockOutgoingCommandsPredicateBuilder()
        handleUpdater = MockRelatedHandleUpdater()
    }
    
    override func tearDown() {
        super.tearDown()
        predicateBuilder = nil
        handleUpdater = nil
    }
    
    func testThatItUsesCorrectServiceMethodAndUpdatesRelatedHandle() {
        // given
        let oldComment = Comment(commentHandle: UUID().uuidString)
        oldComment.topicHandle = UUID().uuidString
        
        let createdComment = Comment(commentHandle: UUID().uuidString)
        createdComment.topicHandle = UUID().uuidString

        let command = CreateCommentCommand(comment: oldComment)
        
        let response = PostCommentResponse()
        response.commentHandle = createdComment.commentHandle
        
        let service = MockCommentsService()
        service.postCommentReturnResponse = response
        
        let sut = CreateCommentOperation(command: command, commentsService: service,
                                         predicateBuilder: predicateBuilder, handleUpdater: handleUpdater)
        
        let predicate = NSPredicate()
        predicateBuilder.commandsWithRelatedHandleIgnoredTypeIDReturnValue = predicate
        
        // when
        let queue = OperationQueue()
        queue.addOperation(sut)
        queue.waitUntilAllOperationsAreFinished()
        
        // then
        // service called
        XCTAssertTrue(service.postCommentTopicHandleRequestPhotoResultHandlerFailureCalled)
        let args = service.postCommentTopicHandleRequestPhotoResultHandlerFailureReceivedArguments
        XCTAssertEqual(args?.topicHandle, command.comment.topicHandle)
        
        // predicate created
        XCTAssertTrue(predicateBuilder.commandsWithRelatedHandleIgnoredTypeIDCalled)
        let builderArgs = predicateBuilder.commandsWithRelatedHandleIgnoredTypeIDReceivedArguments
        XCTAssertEqual(builderArgs?.relatedHandle, oldComment.commentHandle)
        XCTAssertEqual(builderArgs?.ignoredTypeID, command.typeIdentifier)
        
        // related handle updated
        XCTAssertTrue(handleUpdater.updateRelatedHandleFromToPredicateCalled)
        let handleUpdaterArgs = handleUpdater.updateRelatedHandleFromToPredicateReceivedArguments
        XCTAssertEqual(handleUpdaterArgs?.oldHandle, oldComment.commentHandle)
        XCTAssertEqual(handleUpdaterArgs?.newHandle, createdComment.commentHandle)
        XCTAssertEqual(handleUpdaterArgs?.predicate, predicate)
    }
    
    func testThatItFinishesWithErrorWhenServiceFailsToCreateComment() {
        // given
        let comment = Comment(commentHandle: UUID().uuidString)
        comment.topicHandle = UUID().uuidString
        
        let command = CreateCommentCommand(comment: comment)
        
        let service = MockCommentsService()
        service.postCommentReturnError = APIError.unknown
        
        let sut = CreateCommentOperation(command: command, commentsService: service,
                                         predicateBuilder: predicateBuilder, handleUpdater: handleUpdater)
        
        // when
        let queue = OperationQueue()
        queue.addOperation(sut)
        queue.waitUntilAllOperationsAreFinished()
        
        // then
        // service called
        XCTAssertTrue(service.postCommentTopicHandleRequestPhotoResultHandlerFailureCalled)
        let args = service.postCommentTopicHandleRequestPhotoResultHandlerFailureReceivedArguments
        XCTAssertEqual(args?.topicHandle, command.comment.topicHandle)
        
        // predicate created
        XCTAssertFalse(predicateBuilder.commandsWithRelatedHandleIgnoredTypeIDCalled)
        
        // related handle updated
        XCTAssertFalse(handleUpdater.updateRelatedHandleFromToPredicateCalled)
        
        guard let resultError = sut.error as? APIError, case APIError.unknown = resultError else {
            XCTFail("Must contain error returned from service")
            return
        }
    }
}






























