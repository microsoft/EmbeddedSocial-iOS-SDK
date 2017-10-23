//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class UpdateNotificationsStatusCommandTests: XCTestCase {
    
    func testInit() {
        let json = ["handle" : "1"]
        let command = UpdateNotificationsStatusCommand(json: json)
        expect(command).notTo(beNil())
        expect(command?.handle).to(equal("1"))
    }
    
    func testEncodeToJSON() {
        let command = UpdateNotificationsStatusCommand(handle: "1")
        let json = command.encodeToJSON() as? [String: Any]
        expect(json).notTo(beNil())
        expect(json?["handle"] as? String).to(equal("1"))
        expect(json?["type"] as? String).to(equal(command.typeIdentifier))
    }
    
    func testGetHandle() {
        let command = UpdateNotificationsStatusCommand(handle: "1")
        expect(command.getHandle()).to(equal("1"))
    }
}
