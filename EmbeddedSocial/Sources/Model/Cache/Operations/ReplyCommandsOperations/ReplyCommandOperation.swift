//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class ReplyCommandOperation: OutgoingCommandOperation {
    let command: ReplyCommand
    
    init(command: ReplyCommand) {
        self.command = command
        super.init()
    }
}
