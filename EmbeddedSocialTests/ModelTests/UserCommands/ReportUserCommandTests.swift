//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class ReportUserCommandTests: XCTestCase {
    
    func testInitJSON() {
        let user = User()
        let json: [String: Any] = [
            "user": user.encodeToJSON(),
            "reason": ReportReason.other.rawValue,
            "type": "ReportUserCommand"
        ]
        let cmd = ReportUserCommand(json: json)
        expect(cmd?.user).to(equal(user))
        expect(cmd?.reason).to(equal(ReportReason.other))
    }
}
