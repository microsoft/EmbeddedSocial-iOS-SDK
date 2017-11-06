//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class UpdateRelatedHandleCommandTests: XCTestCase {
    
    func testInit() {
        let cmd = UpdateRelatedHandleCommand(handle: "1")
        expect(cmd.handle).to(equal("1"))
    }
    
    func testInitJSON() {
        let cmd = UpdateRelatedHandleCommand(json: ["handle": "1"])
        expect(cmd?.handle).to(equal("1"))
    }
    
    func testHandleGetter() {
        let cmd = UpdateRelatedHandleCommand(handle: "1")
        expect(cmd.getHandle()).to(equal("1"))
    }
}
