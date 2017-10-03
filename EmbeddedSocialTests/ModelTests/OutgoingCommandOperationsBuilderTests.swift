//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class OutgoingCommandOperationsBuilderTests: XCTestCase {
    
    func testThatItReturnsCorrectOperationClass() {
        let builder = OutgoingCommandOperationsBuilder()
        let makeOperation = builder.operation(for:)
        
        // user commands
        let user = User()
        XCTAssertTrue(makeOperation(FollowCommand(user: user)) is FollowUserOperation)
        XCTAssertTrue(makeOperation(UnfollowCommand(user: user)) is UnfollowUserOperation)
        XCTAssertTrue(makeOperation(BlockCommand(user: user)) is EmbeddedSocial.BlockUserOperation)
        XCTAssertTrue(makeOperation(UnblockCommand(user: user)) is UnblockUserOperation)
        XCTAssertTrue(makeOperation(CancelPendingCommand(user: user)) is CancelPendingUserOperation)
        XCTAssertTrue(makeOperation(AcceptPendingCommand(user: user)) is AcceptPendingUserOperation)

        // topic commands
        let topic = Post.mock(seed: 1)
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
        XCTAssertTrue(makeOperation(RemoveReplyCommand(reply: reply)) is RemoveReplyOperation)
        XCTAssertTrue(makeOperation(ReportReplyCommand(reply: reply, reportReason: .other)) is ReportReplyOperation)

        // comment commands
        let comment = Comment(commentHandle: UUID().uuidString)
        XCTAssertTrue(makeOperation(LikeCommentCommand(comment: comment)) is LikeCommentOperation)
        XCTAssertTrue(makeOperation(UnlikeCommentCommand(comment: comment)) is UnlikeCommentOperation)
        XCTAssertTrue(makeOperation(CreateCommentCommand(comment: comment)) is CreateCommentOperation)
        XCTAssertTrue(makeOperation(RemoveCommentCommand(comment: comment)) is RemoveCommentOperation)
        XCTAssertTrue(makeOperation(ReportCommentCommand(comment: comment, reportReason: .other)) is ReportCommentOperation)
        
        // image commands
        let photo = Photo(image: UIImage(color: .yellow, size: CGSize(width: 8.0, height: 8.0)))
        let relatedHandle = UUID().uuidString
        XCTAssertTrue(makeOperation(CreateTopicImageCommand(photo: photo, relatedHandle: relatedHandle)) is CreateTopicImageOperation)
        XCTAssertTrue(makeOperation(CreateCommentImageCommand(photo: photo, relatedHandle: relatedHandle)) is CreateCommentImageOperation)
        XCTAssertTrue(makeOperation(UpdateUserImageCommand(photo: photo, relatedHandle: relatedHandle)) is UpdateUserImageOperation)
    }
}
