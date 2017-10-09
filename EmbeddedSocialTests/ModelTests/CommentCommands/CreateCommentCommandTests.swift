//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CreateCommentCommandTests: XCTestCase {
    
    func testThatItReturnsCorrectInverseCommand() {
        // given
        let comment = Comment(commentHandle: UUID().uuidString)
        let sut = CreateCommentCommand(comment: comment)
        XCTAssertNil(sut.inverseCommand)
    }
}
