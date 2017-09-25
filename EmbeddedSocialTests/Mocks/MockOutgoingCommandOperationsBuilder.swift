//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial
import Foundation

class MockOutgoingCommandOperationsBuilder: OutgoingCommandOperationsBuilderType {
    
    var operationForCommandCalled = false
    var operationForCommandInputCommand: OutgoingCommand?
    var operationForCommandReturnValueMaker: (() -> OutgoingCommandOperation?)!

    func operation(for command: OutgoingCommand) -> OutgoingCommandOperation? {
        operationForCommandCalled = true
        operationForCommandInputCommand = command
        return operationForCommandReturnValueMaker()
    }
    
    var fetchCommandsOperationPredicateCalled = false
    var fetchCommandsOperationPredicateInputValues: (cache: CacheType, predicate: NSPredicate)?
    var fetchCommandsOperationPredicateReturnValueMaker: (() -> FetchOutgoingCommandsOperation)!
    
    func fetchCommandsOperation(cache: CacheType, predicate: NSPredicate) -> FetchOutgoingCommandsOperation {
        fetchCommandsOperationPredicateCalled = true
        fetchCommandsOperationPredicateInputValues = (cache, predicate)
        return fetchCommandsOperationPredicateReturnValueMaker()
    }
}

