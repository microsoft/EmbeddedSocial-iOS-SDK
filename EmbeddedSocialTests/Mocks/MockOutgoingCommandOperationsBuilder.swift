//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial
import Foundation

class MockOutgoingCommandOperationsBuilder: OutgoingCommandOperationsBuilderType {
    
    static var operationForCommandCalled = false
    static var operationForCommandReturnValue: OutgoingCommandOperation?
    static var operationForCommandInputCommand: OutgoingCommand?

    static func operation(for command: OutgoingCommand) -> OutgoingCommandOperation? {
        operationForCommandCalled = true
        operationForCommandInputCommand = command
        return operationForCommandReturnValue
    }
}

