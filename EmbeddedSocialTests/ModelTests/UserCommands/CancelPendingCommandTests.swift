//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CancelPendingCommandTests: XCTestCase {
    
    func testThatItCorrectlyAppliesChanges() {
        // given
        var user = User()
        let sut = CancelPendingCommand(user: user)
        
        // when
        sut.apply(to: &user)
        
        // then
        XCTAssertEqual(user.followerStatus, .empty)
    }
    
    func testThatItReturnsCorrectInverseCommand() {
        // given
        let user = User()
        let sut = CancelPendingCommand(user: user)
        
        // when
        
        // then
        guard let inverseCommand = sut.inverseCommand as? FollowCommand else {
            XCTFail("Must return inverse command")
            return
        }
        XCTAssertEqual(sut.user, inverseCommand.user)
    }
}
