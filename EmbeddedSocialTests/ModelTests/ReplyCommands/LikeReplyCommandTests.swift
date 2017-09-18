//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class LikeReplyCommandTests: XCTestCase {
    
    func testThatItCorrectlyAppliesChanges() {
        // given
        var reply = Reply()
        reply.replyHandle = UUID().uuidString
        let sut = LikeReplyCommand(replyHandle: reply.replyHandle!)
        
        // when
        sut.apply(to: &reply)
        
        // then
        XCTAssertTrue(reply.liked)
        XCTAssertEqual(reply.totalLikes, 1)
    }
    
    func testThatItReturnsCorrectInverseCommand() {
        // given
        let reply = Reply()
        reply.replyHandle = UUID().uuidString
        let sut = LikeReplyCommand(replyHandle: reply.replyHandle!)
        
        // when
        
        // then
        guard let inverseCommand = sut.inverseCommand as? UnlikeReplyCommand else {
            XCTFail("Must return inverse command")
            return
        }
        XCTAssertEqual(sut.replyHandle, inverseCommand.replyHandle)
    }
    
    func testThatItReturnsCorrectCombinedHandle() {
        // given
        let reply = Reply()
        reply.replyHandle = UUID().uuidString
        let sut = LikeReplyCommand(replyHandle: reply.replyHandle!)
        
        // when
        let handle = sut.combinedHandle
        
        // then
        XCTAssertEqual(handle, "LikeReplyCommand-\(reply.replyHandle!)")
    }
}
