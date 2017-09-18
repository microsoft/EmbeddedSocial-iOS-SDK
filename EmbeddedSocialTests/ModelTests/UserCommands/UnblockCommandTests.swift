//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class UnblockCommandTests: XCTestCase {
    
    func testThatItCorrectlyAppliesChanges() {
        // given
        var user = User()
        let sut = UnblockCommand(user: user)
        
        // when
        sut.apply(to: &user)
        
        // then
        XCTAssertEqual(user.followingStatus, .empty)
    }
    
    func testThatItReturnsCorrectInverseCommand() {
        // given
        let user = User()
        let sut = UnblockCommand(user: user)
        
        // when
        
        // then
        guard let inverseCommand = sut.inverseCommand as?  BlockCommand else {
            XCTFail("Must return inverse command")
            return
        }
        XCTAssertEqual(sut.user, inverseCommand.user)
    }
    
    func testThatItReturnsCorrectCombinedHandle() {
        // given
        let user = User()
        let sut = UnblockCommand(user: user)
        
        // when
        let handle = sut.combinedHandle
        
        // then
        XCTAssertEqual(handle, "UnblockCommand-\(user.uid)")
    }
}
