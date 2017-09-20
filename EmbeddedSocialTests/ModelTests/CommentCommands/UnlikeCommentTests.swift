//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class UnlikeCommentCommandTests: XCTestCase {
    
    func testThatItCorrectlyAppliesChanges() {
        // given
        var comment = Comment(commentHandle: UUID().uuidString)
        let sut = UnlikeCommentCommand(comment: comment)
        
        // when
        sut.apply(to: &comment)
        
        // then it doesn't cross zero boundary
        XCTAssertFalse(comment.liked)
        XCTAssertEqual(comment.totalLikes, 0)
        
        // when
        comment.totalLikes = 3
        sut.apply(to: &comment)
        
        // then
        XCTAssertEqual(comment.totalLikes, 2)
    }
    
    func testThatItReturnsCorrectInverseCommand() {
        // given
        let comment = Comment(commentHandle: UUID().uuidString)
        let sut = UnlikeCommentCommand(comment: comment)
        
        // when
        
        // then
        guard let inverseCommand = sut.inverseCommand as? LikeCommentCommand else {
            XCTFail("Must return inverse command")
            return
        }
        XCTAssertEqual(sut.comment, inverseCommand.comment)
    }
}
