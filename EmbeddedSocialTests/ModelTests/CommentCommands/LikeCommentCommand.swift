//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class LikeCommentCommandTests: XCTestCase {
    
    func testThatItCorrectlyAppliesChanges() {
        // given
        var comment = Comment(commentHandle: UUID().uuidString)
        let sut = LikeCommentCommand(comment: comment)
        
        // when
        sut.apply(to: &comment)
        
        // then
        XCTAssertTrue(comment.liked)
        XCTAssertEqual(comment.totalLikes, 1)
    }
    
    func testThatItReturnsCorrectInverseCommand() {
        // given
        let comment = Comment(commentHandle: UUID().uuidString)
        let sut = LikeCommentCommand(comment: comment)
        
        // when
        
        // then
        guard let inverseCommand = sut.inverseCommand as? UnlikeCommentCommand else {
            XCTFail("Must return inverse command")
            return
        }
        XCTAssertEqual(sut.comment.commentHandle, inverseCommand.comment.commentHandle)
    }
}
