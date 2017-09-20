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
        let topic = Post(topicHandle: UUID().uuidString)
        XCTAssertTrue(makeOperation(UnlikeTopicCommand(topic: topic)) is UnlikeTopicOperation)
        XCTAssertTrue(makeOperation(LikeTopicCommand(topic: topic)) is LikeTopicOperation)
        XCTAssertTrue(makeOperation(PinTopicCommand(topic: topic)) is PinTopicOperation)
        XCTAssertTrue(makeOperation(UnpinTopicCommand(topic: topic)) is UnpinTopicOperation)
        XCTAssertTrue(makeOperation(CreateTopicCommand(topic: topic)) is CreateTopicOperation)
        
        // reply commands
        let reply = Reply(replyHandle: UUID().uuidString)
        XCTAssertTrue(makeOperation(LikeReplyCommand(reply: reply)) is LikeReplyOperation)
        XCTAssertTrue(makeOperation(UnlikeReplyCommand(reply: reply)) is UnlikeReplyOperation)
        XCTAssertTrue(makeOperation(CreateReplyCommand(reply: reply)) is CreateReplyOperation)

        // comment commands
        let comment = Comment(commentHandle: UUID().uuidString)
        XCTAssertTrue(makeOperation(LikeCommentCommand(comment: comment)) is LikeCommentOperation)
        XCTAssertTrue(makeOperation(UnlikeCommentCommand(comment: comment)) is UnlikeCommentOperation)
        XCTAssertTrue(makeOperation(CreateCommentCommand(comment: comment)) is CreateCommentOperation)
        
        // image commands
        let photo = Photo(image: UIImage(color: .yellow, size: CGSize(width: 8.0, height: 8.0)))
        let relatedHandle = UUID().uuidString
        XCTAssertTrue(makeOperation(CreateTopicImageCommand(photo: photo, relatedHandle: relatedHandle)) is CreateTopicImageOperation)
        XCTAssertTrue(makeOperation(CreateCommentImageCommand(photo: photo, relatedHandle: relatedHandle)) is CreateCommentImageOperation)
        XCTAssertTrue(makeOperation(UpdateUserImageCommand(photo: photo, relatedHandle: relatedHandle)) is UpdateUserImageOperation)
    }
}
