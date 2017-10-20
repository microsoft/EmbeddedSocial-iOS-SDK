//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockRelatedHandleUpdater: RelatedHandleUpdater {
    
    //MARK: - updateRelatedHandle
    
    var updateRelatedHandleFromToPredicateCalled = false
    var updateRelatedHandleFromToPredicateReceivedArguments: (oldHandle: String?, newHandle: String?, predicate: NSPredicate)?
    
    func updateRelatedHandle(from oldHandle: String?, to newHandle: String?, predicate: NSPredicate) {
        updateRelatedHandleFromToPredicateCalled = true
        updateRelatedHandleFromToPredicateReceivedArguments = (oldHandle: oldHandle, newHandle: newHandle, predicate: predicate)
    }
    
    //MARK: - updateCommand
    
    var updateCommandOldHandleUpdatedCommandCalled = false
    var updateCommandOldHandleUpdatedCommandReceivedArguments: (oldHandle: String, updatedCommand: OutgoingCommand)?
    
    func updateCommand(oldHandle: String, updatedCommand: OutgoingCommand) {
        updateCommandOldHandleUpdatedCommandCalled = true
        updateCommandOldHandleUpdatedCommandReceivedArguments = (oldHandle: oldHandle, updatedCommand: updatedCommand)
    }
    
}
