//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class ReportReplyCommandTests: XCTestCase {
    
    func testInitJSON() {
        let reply = Reply(replyHandle: "1")
        let json: [String: Any] = [
            "reply": reply.encodeToJSON(),
            "type": "ReportReplyCommand",
            "reportReason": ReportReason.childEndangermentExploitation.rawValue
        ]
        let cmd = ReportReplyCommand(json: json)
        XCTAssertEqual(cmd?.reply, reply)
        XCTAssertEqual(cmd?.reportReason.rawValue, ReportReason.childEndangermentExploitation.rawValue)
    }
    
}
