//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class BlockUserOperationTests: XCTestCase {
    
    func testThatItUsesCorrectServiceMethod() {
        // given
        let command = UserCommand(user: User())
        let service = MockSocialService()
        let sut = EmbeddedSocial.BlockUserOperation(command: command, socialService: service)
        
        // when
        let queue = OperationQueue()
        queue.addOperation(sut)
        queue.waitUntilAllOperationsAreFinished()
        
        // then
        XCTAssertEqual(service.blockCount, 1)
        XCTAssertEqual(service.blockInputUser, command.user)
    }
}

