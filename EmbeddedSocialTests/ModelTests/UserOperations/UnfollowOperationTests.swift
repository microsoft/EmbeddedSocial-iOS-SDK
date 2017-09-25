//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class UnfollowUserOperationTests: XCTestCase {
    
    func testThatItUsesCorrectServiceMethod() {
        // given
        let command = UserCommand(user: User())
        let service = MockSocialService()
        let sut = UnfollowUserOperation(command: command, socialService: service)
        
        // when
        let queue = OperationQueue()
        queue.addOperation(sut)
        queue.waitUntilAllOperationsAreFinished()
        
        // then
        XCTAssertEqual(service.unfollowCount, 1)
        XCTAssertEqual(service.unfollowInputUser, command.user)
    }
}
