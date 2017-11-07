//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//


import XCTest
@testable import EmbeddedSocial

class RemoveCommentCommandTests: XCTestCase {
    
    func testThatItReturnsCorrectInverseCommand() {
        // given
        let comment = Comment(commentHandle: UUID().uuidString)
        let sut = RemoveCommentCommand(comment: comment)
        guard let inverse = sut.inverseCommand as? CreateCommentCommand else {
            XCTFail()
            return
        }
        XCTAssertEqual(sut.comment, inverse.comment)
    }
    
}
