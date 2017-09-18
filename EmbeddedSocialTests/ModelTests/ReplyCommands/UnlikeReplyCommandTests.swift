//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class UnlikeReplyCommandTests: XCTestCase {
    
    func testThatItCorrectlyAppliesChanges() {
        // given
        var reply = Reply()
        reply.replyHandle = UUID().uuidString
        let sut = UnlikeReplyCommand(replyHandle: reply.replyHandle!)
        
        // when
        sut.apply(to: &reply)
        
        // then it doesn't cross zero boundary
        XCTAssertFalse(reply.liked)
        XCTAssertEqual(reply.totalLikes, 0)
        
        // when
        reply.totalLikes = 3
        sut.apply(to: &reply)
        
        // then
        XCTAssertEqual(reply.totalLikes, 2)
    }
    
    func testThatItReturnsCorrectInverseCommand() {
        // given
        let reply = Reply()
        reply.replyHandle = UUID().uuidString
        let sut = UnlikeReplyCommand(replyHandle: reply.replyHandle!)
        
        // when
        
        // then
        guard let inverseCommand = sut.inverseCommand as? LikeReplyCommand else {
            XCTFail("Must return inverse command")
            return
        }
        XCTAssertEqual(sut.replyHandle, inverseCommand.replyHandle)
    }
    
    func testThatItReturnsCorrectCombinedHandle() {
        // given
        let reply = Reply()
        reply.replyHandle = UUID().uuidString
        let sut = UnlikeReplyCommand(replyHandle: reply.replyHandle!)
        
        // when
        let handle = sut.combinedHandle
        
        // then
        XCTAssertEqual(handle, "UnlikeReplyCommand-\(reply.replyHandle!)")
    }
}
