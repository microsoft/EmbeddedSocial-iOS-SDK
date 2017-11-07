//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class UpdateRelatedHandleCommandTests: XCTestCase {
    
    func testInit() {
        let cmd = UpdateRelatedHandleCommand(oldHandle: "1", newHandle: "2")
        expect(cmd.oldHandle).to(equal("1"))
        expect(cmd.newHandle).to(equal("2"))
    }
    
    func testInitJSON() {
        let cmd = UpdateRelatedHandleCommand(json: ["oldHandle": "1", "newHandle": "2"])
        expect(cmd?.oldHandle).to(equal("1"))
        expect(cmd?.newHandle).to(equal("2"))
    }
    
    func testHandleGetter() {
        let cmd = UpdateRelatedHandleCommand(oldHandle: "1", newHandle: "2")
        expect(cmd.getHandle()).to(equal("1-2"))
    }
}
