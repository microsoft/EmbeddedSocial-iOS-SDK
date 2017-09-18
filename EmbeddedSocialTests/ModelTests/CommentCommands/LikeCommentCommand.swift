//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class LikeCommentCommandTests: XCTestCase {
    
    func testThatItCorrectlyAppliesChanges() {
        // given
        var comment = Comment()
        comment.commentHandle = UUID().uuidString
        let sut = LikeCommentCommand(commentHandle: comment.commentHandle!)
        
        // when
        sut.apply(to: &comment)
        
        // then
        XCTAssertTrue(comment.liked)
        XCTAssertEqual(comment.totalLikes, 1)
    }
    
    func testThatItReturnsCorrectInverseCommand() {
        // given
        let comment = Comment()
        comment.commentHandle = UUID().uuidString
        let sut = LikeCommentCommand(commentHandle: comment.commentHandle!)
        
        // when
        
        // then
        guard let inverseCommand = sut.inverseCommand as? UnlikeCommentCommand else {
            XCTFail("Must return inverse command")
            return
        }
        XCTAssertEqual(sut.commentHandle, inverseCommand.commentHandle)
    }
    
    func testThatItReturnsCorrectCombinedHandle() {
        // given
        let comment = Comment()
        comment.commentHandle = UUID().uuidString
        let sut = LikeCommentCommand(commentHandle: comment.commentHandle!)
        
        // when
        let handle = sut.combinedHandle
        
        // then
        XCTAssertEqual(handle, "LikeCommentCommand-\(comment.commentHandle!)")
    }
}
