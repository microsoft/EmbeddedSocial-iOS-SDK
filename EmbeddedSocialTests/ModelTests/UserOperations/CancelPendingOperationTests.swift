//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CancelPendingOperationTests: XCTestCase {
    
    func testThatItUsesCorrectServiceMethod() {
        // given
        let command = UserCommand(user: User())
        let service = MockSocialService()
        let sut = CancelPendingOperation(command: command, socialService: service)
        
        // when
        let queue = OperationQueue()
        queue.addOperation(sut)
        queue.waitUntilAllOperationsAreFinished()
        
        // then
        XCTAssertEqual(service.cancelPendingCount, 1)
        XCTAssertEqual(service.cancelPendingInputUser, command.user)
    }
}
