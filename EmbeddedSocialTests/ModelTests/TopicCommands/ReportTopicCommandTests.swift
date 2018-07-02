//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class ReportTopicCommandTests: XCTestCase {
    
    func testInitInvalidJSON() {
        let json: [String: Any] = [:]
        let cmd = ReportTopicCommand(json: json)
        expect(cmd).to(beNil())
    }
    
    func testInitJSON() {
        let topic = Post(topicHandle: "1")
        let json: [String: Any] = [
            "topic": topic.encodeToJSON(),
            "type": "ReportTopicCommand",
            "reason": ReportReason._none.rawValue
        ]
        let cmd = ReportTopicCommand(json: json)
        expect(cmd?.reason).to(equal(._none))
        expect(cmd?.topic).to(equal(topic))
    }
}
