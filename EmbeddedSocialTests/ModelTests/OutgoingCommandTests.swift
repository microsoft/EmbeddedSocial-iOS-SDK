//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class OutgoingCommandTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatItCreatesUserCommandsFromJSON() {
        let userCommands: [UserCommand.Type] = [
            FollowCommand.self,
            UnfollowCommand.self,
            BlockCommand.self,
            UnblockCommand.self,
            CancelPendingCommand.self
        ]
        
        let user = User()
        
        testThatItCreatesCommands(
            ofTypes: userCommands,
            jsonBuilder: { type in ["user": user.encodeToJSON(), "type": type.typeIdentifier] },
            validator: { command, _ in
                XCTAssertEqual((command as? UserCommand)?.user, user)
        })
    }
    
    func testThatItCreatesTopicCommandsFromJSON() {
        let topicCommands: [TopicCommand.Type] = [
            UnlikeTopicCommand.self,
            LikeTopicCommand.self,
            PinTopicCommand.self,
            UnpinTopicCommand.self,
            ]
        
        let topicHandle = UUID().uuidString
        
        testThatItCreatesCommands(
            ofTypes: topicCommands,
            jsonBuilder: { type in ["topicHandle": topicHandle, "type": type.typeIdentifier] },
            validator: { command, _ in
                XCTAssertEqual((command as? TopicCommand)?.topicHandle, topicHandle)
        })
    }
    
    func testThatItCreatesReplyCommandsFromJSON() {
        let replyCommands: [ReplyCommand.Type] = [
            UnlikeReplyCommand.self,
            LikeReplyCommand.self
        ]
        
        let replyHandle = UUID().uuidString
        
        testThatItCreatesCommands(
            ofTypes: replyCommands,
            jsonBuilder: { type in ["replyHandle": replyHandle, "type": type.typeIdentifier] },
            validator: { command, _ in
                XCTAssertEqual((command as? ReplyCommand)?.replyHandle, replyHandle)
        })
    }
    
    func testThatItCreatesCommentCommandsFromJSON() {
        let commentCommands: [CommentCommand.Type] = [
            UnlikeCommentCommand.self,
            LikeCommentCommand.self
        ]
        
        let commentHandle = UUID().uuidString
        
        testThatItCreatesCommands(
            ofTypes: commentCommands,
            jsonBuilder: { type in ["commentHandle": commentHandle, "type": type.typeIdentifier] },
            validator: { command, _ in
                XCTAssertEqual((command as? CommentCommand)?.commentHandle, commentHandle)
        })
    }
    
    func testThatItCreatesCommands(ofTypes commandTypes: [OutgoingCommand.Type],
                                   jsonBuilder: (OutgoingCommand.Type) -> [String: Any],
                                   validator: (OutgoingCommand, OutgoingCommand.Type) -> Void) {
        // given
        let jsons = commandTypes.map(jsonBuilder)
        
        // when
        let commands = jsons.flatMap(OutgoingCommand.command)
        
        // then
        for case let (index, command) as (Int, TopicCommand) in commands.enumerated() {
            let commandType = commandTypes[index]
            validator(command, commandType)
            XCTAssertEqual(command.typeIdentifier, commandType.typeIdentifier)
        }
        
        XCTAssertEqual(commands.count, commandTypes.count)
    }
    
    func testThatItReturnsCorrectCombinedHandle() {
        // given
        let user = User()
        let sut = UserCommand(user: user)
        
        // when
        let handle = sut.combinedHandle
        
        // then
        XCTAssertEqual(handle, "UserCommand-\(user.uid)")
    }
}

