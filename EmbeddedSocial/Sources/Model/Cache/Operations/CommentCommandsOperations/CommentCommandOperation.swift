//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class CommentCommandOperation: OutgoingCommandOperation {
    let command: CommentCommand
    
    init(command: CommentCommand) {
        self.command = command
        super.init()
    }
    
}
