//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//


import XCTest
@testable import EmbeddedSocial

class ReportCommentCommandTests: XCTestCase {
    
    func testThatItReturnsCorrectInverseCommand() {
        // given
        let comment = Comment(commentHandle: UUID().uuidString)
        let sut = ReportCommentCommand(comment: comment, reportReason: .other)
        XCTAssertNil(sut.inverseCommand)
    }
    
}
