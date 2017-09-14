//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class FollowCommandTests: XCTestCase {
    
    func testThatItCorrectlyAppliesChanges() {
        let user1 = User(visibility: ._public)
        testThatItCorrectlyAppliesChanges(to: user1, expectedFollowerStatus: .accepted)
        
        let user2 = User(visibility: ._private)
        testThatItCorrectlyAppliesChanges(to: user2, expectedFollowerStatus: .pending)
    }
    
    func testThatItCorrectlyAppliesChanges(to user: User, expectedFollowerStatus: FollowStatus) {
        // given
        var user = user
        let sut = FollowCommand(user: user)
        
        // when
        sut.apply(to: &user)
        
        // then
        XCTAssertEqual(user.followerStatus, expectedFollowerStatus)
    }
    
    func testThatItReturnsCorrectInverseCommand() {
        let user1 = User(visibility: ._public)
        testThatItReturnsCorrectInverseCommand(with: user1, expectedCommandType: UnfollowCommand.self)
        
        let user2 = User(visibility: ._private)
        testThatItReturnsCorrectInverseCommand(with: user2, expectedCommandType: CancelPendingCommand.self)
    }
    
    func testThatItReturnsCorrectInverseCommand<T: UserCommand>(with user: User, expectedCommandType: T.Type) {
        // given
        let sut = FollowCommand(user: user)
        
        // when
        
        // then
        guard let inverseCommand = sut.inverseCommand else {
            XCTFail("Must return inverse command")
            return
        }
        XCTAssertTrue(inverseCommand is T)
        XCTAssertEqual(sut.user, inverseCommand.user)
    }
    
    func testThatItReturnsCorrectCombinedHandle() {
        // given
        let user = User()
        let sut = FollowCommand(user: user)
        
        // when
        let handle = sut.combinedHandle
        
        // then
        XCTAssertEqual(handle, "FollowCommand-\(user.uid)")
    }
}
