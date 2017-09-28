//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class ReportReplyCommandTests: XCTestCase {
    
    func testThatItReturnsCorrectInverseCommand() {
        // given
        let reply = Reply(replyHandle: UUID().uuidString)
        let sut = RemoveReplyCommand(reply: reply)
        XCTAssertNil(sut.inverseCommand)
    }
    
}
