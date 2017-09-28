//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

final class MockFetchUserCommandsOperation: FetchUserCommandsOperation {
    
    override var commands: [UserCommand] {
        get {
            return _commands
        }
        set {
            // nothing
        }
    }
    
    private var _commands: [UserCommand] = []
    
    func setCommands(_ commands: [UserCommand]) {
        _commands = commands
    }
}
