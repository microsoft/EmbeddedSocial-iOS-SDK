//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class UpdateRelatedHandleOperationTests: XCTestCase {
    
    func testExecute() {
        let cmd = UpdateRelatedHandleCommand(oldHandle: "1", newHandle: "2")
        let updater = MockHandleUpdater()
        
        let queue = OperationQueue()
        queue.addOperation(UpdateRelatedHandleOperation(command: cmd, handleUpdater: updater))
        queue.waitUntilAllOperationsAreFinished()
        
        expect(updater.updateHandleToPredicateCalled).to(beTrue())
        let args = updater.updateHandleToPredicateReceivedArguments
        expect(args?.newHandle).to(equal("2"))
        expect(args?.predicate).to(equal(NSPredicate(format: "handle = '1'")))
    }
}
