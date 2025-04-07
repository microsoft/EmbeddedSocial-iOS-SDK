//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class AcceptPendingCommandTests: XCTestCase {
    
    func testThatItCorrectlyAppliesChanges() {
        var user = User()
        let sut = AcceptPendingCommand(user: user)
        sut.apply(to: &user)
        expect(user.followerStatus).to(equal(.accepted))
    }
    
    func testThatItReturnsCorrectInverseCommand() {
        let sut = AcceptPendingCommand(user: User())
        expect(sut.inverseCommand).to(beNil())
    }
}
