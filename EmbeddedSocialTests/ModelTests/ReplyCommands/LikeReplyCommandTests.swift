//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class LikeReplyCommandTests: XCTestCase {
    
    func testThatItCorrectlyAppliesChanges() {
        // given
        var reply = Reply(replyHandle: UUID().uuidString)
        let sut = LikeReplyCommand(reply: reply)
        
        // when
        sut.apply(to: &reply)
        
        // then
        XCTAssertTrue(reply.liked)
        XCTAssertEqual(reply.totalLikes, 1)
    }
    
    func testThatItReturnsCorrectInverseCommand() {
        // given
        let reply = Reply(replyHandle: UUID().uuidString)
        let sut = LikeReplyCommand(reply: reply)
        
        // when
        
        // then
        guard let inverseCommand = sut.inverseCommand as? UnlikeReplyCommand else {
            XCTFail("Must return inverse command")
            return
        }
        XCTAssertEqual(sut.reply, inverseCommand.reply)
    }
}
