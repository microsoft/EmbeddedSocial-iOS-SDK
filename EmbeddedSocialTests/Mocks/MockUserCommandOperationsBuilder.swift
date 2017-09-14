//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial
import Foundation

class MockUserCommandOperationsBuilder: UserCommandOperationsBuilderType {
    
    static var operationForCommandCalled = false
    static var operationForCommandReturnValue: Operation?
    static var operationForCommandInputCommand: UserCommand?

    static func operation(for command: UserCommand) -> Operation? {
        operationForCommandCalled = true
        operationForCommandInputCommand = command
        return operationForCommandReturnValue
    }
}

