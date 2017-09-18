//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class OutgoingCommandOperationsBuilderTests: XCTestCase {
    
    func testThatItReturnsCorrectOperationClass() {
        let makeOperation = OutgoingCommandOperationsBuilder.operation(for:)
        
        // user commands
        let user = User()
        XCTAssertTrue(makeOperation(FollowCommand(user: user)) is FollowOperation)
        XCTAssertTrue(makeOperation(UnfollowCommand(user: user)) is UnfollowOperation)
        XCTAssertTrue(makeOperation(BlockCommand(user: user)) is EmbeddedSocial.BlockOperation)
        XCTAssertTrue(makeOperation(UnblockCommand(user: user)) is UnblockOperation)
        XCTAssertTrue(makeOperation(CancelPendingCommand(user: user)) is CancelPendingOperation)
        
        // topic commands
        let topicHandle = UUID().uuidString
        XCTAssertTrue(makeOperation(UnlikeTopicCommand(topicHandle: topicHandle)) is UnlikeTopicOperation)
        XCTAssertTrue(makeOperation(LikeTopicCommand(topicHandle: topicHandle)) is LikeTopicOperation)
        XCTAssertTrue(makeOperation(PinTopicCommand(topicHandle: topicHandle)) is PinTopicOperation)
        XCTAssertTrue(makeOperation(UnpinTopicCommand(topicHandle: topicHandle)) is UnpinTopicOperation)
        
        // reply commands
        let replyHandle = UUID().uuidString
        XCTAssertTrue(makeOperation(LikeReplyCommand(replyHandle: replyHandle)) is LikeReplyOperation)
        XCTAssertTrue(makeOperation(UnlikeReplyCommand(replyHandle: replyHandle)) is UnlikeReplyOperation)
        
        // comment commands
        let commentHandle = UUID().uuidString
        XCTAssertTrue(makeOperation(LikeCommentCommand(commentHandle: commentHandle)) is LikeCommentOperation)
        XCTAssertTrue(makeOperation(UnlikeCommentCommand(commentHandle: commentHandle)) is UnlikeCommentOperation)
    }
}
