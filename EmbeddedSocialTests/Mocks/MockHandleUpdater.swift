//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockHandleUpdater: HandleUpdater {
    
    //MARK: - updateHandle
    
    var updateHandleToPredicateCalled = false
    var updateHandleToPredicateReceivedArguments: (newHandle: String?, predicate: NSPredicate)?
    
    func updateHandle(to newHandle: String?, predicate: NSPredicate) {
        updateHandleToPredicateCalled = true
        updateHandleToPredicateReceivedArguments = (newHandle: newHandle, predicate: predicate)
    }
    
}
