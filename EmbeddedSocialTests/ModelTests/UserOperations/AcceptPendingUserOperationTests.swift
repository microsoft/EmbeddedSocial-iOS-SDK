//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class AcceptPendingUserOperationTests: XCTestCase {
    
    func testThatItUsesCorrectServiceMethod() {
        // given
        let service = MockSocialService()
        service.acceptPendingReturnResult = .success()
        
        let command = UserCommand(user: User())
        let sut = AcceptPendingUserOperation(command: command, socialService: service)
        
        // when
        let queue = OperationQueue()
        queue.addOperation(sut)
        queue.waitUntilAllOperationsAreFinished()
        
        // then
        expect(service.acceptPendingCalled).to(beTrue())
        expect(service.acceptPendingInputUser).to(equal(command.user))
    }
}
