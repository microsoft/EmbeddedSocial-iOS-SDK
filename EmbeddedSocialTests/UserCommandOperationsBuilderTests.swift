//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class UserCommandOperationsBuilderTests: XCTestCase {
    
    func testThatItReturnsCorrectOperationClass() {
        let user = User()
        let makeOperation = UserCommandOperationsBuilder.operation(for:)
        
        XCTAssertTrue(makeOperation(FollowCommand(user: user)) is FollowOperation)
        XCTAssertTrue(makeOperation(UnfollowCommand(user: user)) is UnfollowOperation)
        XCTAssertTrue(makeOperation(BlockCommand(user: user)) is EmbeddedSocial.BlockOperation)
        XCTAssertTrue(makeOperation(UnblockCommand(user: user)) is UnblockOperation)
        XCTAssertTrue(makeOperation(CancelPendingCommand(user: user)) is CancelPendingOperation)
    }
}
